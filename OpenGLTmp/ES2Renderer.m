//
//  ES2Renderer.m
//  OpenGLTmp
//
//  Created by SMT Software on 10.01.2012.
//  Copyright (c) 2012 SMTSoftware. All rights reserved.
//

#import "ES2Renderer.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import <QuartzCore/QuartzCore.h>
#import "GLTriangle.h"

@interface ES2Renderer ()

@end

@implementation ES2Renderer

@synthesize triangle = _triangle;

- (id)init
{
	if ( (self = [super init]) )
	{
		_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		if ( !_context || ![EAGLContext setCurrentContext:_context] )
		{
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
		
		_triangle = [[GLTriangle alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_triangle release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark ESRenderer

- (void)resizeFromLayer:(CAEAGLLayer*)layer
{
	glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_width);
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_height);
	
	glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _width, _height);
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
}

- (void)render
{
	glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
	glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glEnable(GL_DEPTH_TEST);
	
	glViewport(0, 0, _width, _height);
	
	[_triangle use];
	[_triangle render:_width height:_height];
	
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

@end
