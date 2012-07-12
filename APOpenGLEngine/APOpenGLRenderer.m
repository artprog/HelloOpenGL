//
//  APOpenGLRenderer.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 04.07.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "APOpenGLRenderer.h"
#import <QuartzCore/QuartzCore.h>
#import "APOpenGLObject.h"

@interface APOpenGLRenderer ()
- (void)render;
@end

@implementation APOpenGLRenderer

- (id)init
{
    if ( (self = [super init]) )
    {
		_mutexQueue = dispatch_queue_create("pl.artprog.APOpenGLScene_mutexQueue", 0);
		_refreshRate = 20.f;
		
		_objects = [[NSMutableArray alloc] init];
		
		_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		if ( !_context || ![EAGLContext setCurrentContext:_context] )
		{
			NSLog(@"cannot create EAGLContext!");
			return nil;
		}
		
		glGenRenderbuffers(1, &_colorRenderBuffer);
		glGenRenderbuffers(1, &_depthRenderBuffer);
		glGenFramebuffers(1, &_frameBuffer);
		
		glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
		glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
		glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
		
		glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
		glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
    }
    return self;
}

- (void)dealloc
{
	[_displayLink invalidate];
	dispatch_release(_mutexQueue);
	if ( [EAGLContext currentContext] == _context )
	{
		[EAGLContext setCurrentContext:nil];
	}
	[_context release];
	[_objects release];
	
	[super dealloc];
}

- (void)resizeFromLayer:(CAEAGLLayer*)layer
{
	if ( ![NSThread isMainThread] )
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			[self resizeFromLayer:layer];
		});
		return;
	}
	if ( [EAGLContext currentContext] != _context )
	{
		if ( ![EAGLContext setCurrentContext:_context] )
		{
			return;
		}
	}
	glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_width);
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_height);
	
	glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _width, _height);
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
}

- (void)setRefreshRate:(CGFloat)refreshRate
{
	dispatch_async(_mutexQueue, ^{
		_refreshRate = refreshRate;
		_refreshRate = MAX(_refreshRate, 0.f);
		_refreshRate = MIN(_refreshRate, 60.f);
	});
}

- (CGFloat)refreshRate
{
	__block CGFloat refreshRate;
	dispatch_sync(_mutexQueue, ^{
		refreshRate = _refreshRate;
	});
	return refreshRate;
}

- (BOOL)isRendering
{
	__block BOOL isRendering;
	dispatch_sync(_mutexQueue, ^{
		isRendering = _rendering;
	});
	return isRendering;
}

- (void)startRendering
{
	dispatch_async(_mutexQueue, ^{
		if ( !_rendering && _refreshRate > 0.f )
		{
			_displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render)];
			NSInteger frameInterval = floorf(60.f/_refreshRate);
			[_displayLink setFrameInterval:frameInterval];
			[_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
			_rendering = YES;
		}
	});
}

- (void)stopRendering
{
	dispatch_async(_mutexQueue, ^{
		if ( _rendering )
		{
			[_displayLink invalidate], _displayLink = nil;
			_rendering = NO;
		}
	});
}

- (void)renderSingleFrame
{
	if ( ![NSThread isMainThread] )
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			[self renderSingleFrame];
		});
		return;
	}
	[self render];
}

#pragma mark -
#pragma mark APOpenGLRenderer

- (void)render
{
	if ( [EAGLContext currentContext] != _context )
	{
		if ( ![EAGLContext setCurrentContext:_context] )
		{
			return;
		}
	}
	
	glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
	glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glEnable(GL_DEPTH_TEST);
	
	glViewport(0, 0, _width, _height);
	
	for (APOpenGLObject *object in _objects)
	{
		if ( ![object isLoaded] )
		{
			[object load];
		}
		[object render];
	}
	
//	[_triangle use];
//	[_triangle render:_width height:_height];
	
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

@end
