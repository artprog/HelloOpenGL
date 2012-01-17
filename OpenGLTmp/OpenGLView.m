//
//  OpenGLView.m
//  OpenGLTmp
//
//  Created by SMT Software on 10.01.2012.
//  Copyright (c) 2012 SMTSoftware. All rights reserved.
//

#import "OpenGLView.h"
#import <QuartzCore/QuartzCore.h>
#import "ES2Renderer.h"
#import "GLTriangle.h"

@interface OpenGLView ()
- (void)drawView;
- (void)applicationDidBecomeActive;
- (void)applicationWillResignActive;
- (void)panGestureRecognizer:(UIPanGestureRecognizer*)sender;
@end

@implementation OpenGLView

@synthesize animating = _animating;
@synthesize animationFrameInterval = _animationFrameInterval;

- (id)initWithFrame:(CGRect)frame
{
    if ( (self = [super initWithFrame:frame]) )
    {
		CAEAGLLayer *layer = (CAEAGLLayer*)self.layer;
		layer.opaque = YES;
		
		_animationFrameInterval = 3;
		_renderer = [[ES2Renderer alloc] init];
		if ( !_renderer )
		{
			return nil;
		}
		self.backgroundColor = [UIColor whiteColor];
		
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
		[nc addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
		
		UIPanGestureRecognizer *panGestureRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)] autorelease];
		[self addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self stopAnimation];
	
	[_renderer release];
	
	[super dealloc];
}

- (void)layoutSubviews
{
	[_renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
}

+ (Class)layerClass
{
	return [CAEAGLLayer class];
}

- (void)startAnimation
{
	@synchronized(self)
	{
		if ( !_animating )
		{
			_displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView)];
			[_displayLink setFrameInterval:_animationFrameInterval];
			[_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
			_animating = YES;
		}
	}
}

- (void)stopAnimation
{
	@synchronized(self)
	{
		if ( _animating )
		{
			[_displayLink invalidate];
            _displayLink = nil;
			_animating = NO;
		}
	}
}

#pragma mark -
#pragma mark OpenGLView ()

- (void)drawView
{
	[_renderer render];
}

- (void)applicationDidBecomeActive
{
	[self startAnimation];
}

- (void)applicationWillResignActive
{
	[self stopAnimation];
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer*)sender
{
	CGPoint translation = [sender translationInView:self];
	GLTriangle *triangle = [(ES2Renderer*)_renderer triangle];
	CGSize size = self.bounds.size;
	
	static CGFloat oldProjectionAngleX = 0;
	static CGFloat oldProjectionAngleY = 0;
	CGFloat newProjectAngleX = (-translation.y*M_PI)/size.height;
	CGFloat newProjectAngleY = (-translation.x*M_PI)/size.width;
	
	if ( sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged )
	{
		triangle.projectionAngleX -= oldProjectionAngleX - newProjectAngleX;
		oldProjectionAngleX = newProjectAngleX;
		
		triangle.projectionAngleY -= oldProjectionAngleY - newProjectAngleY;
		oldProjectionAngleY = newProjectAngleY;
	}
	if ( sender.state == UIGestureRecognizerStateEnded )
	{
		oldProjectionAngleX = 0;
		oldProjectionAngleY = 0;
	}
}

@end