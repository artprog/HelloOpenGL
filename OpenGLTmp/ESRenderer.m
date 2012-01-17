//
//  ESRenderer.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 10.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "ESRenderer.h"

@implementation ESRenderer

- (void)dealloc
{
	[_context release];
	
	if ( _colorRenderBuffer )
	{
		glDeleteRenderbuffers(1, &_colorRenderBuffer);
	}
	if ( _frameBuffer )
	{
		glDeleteFramebuffers(1, &_frameBuffer);
	}
	if ( _depthRenderBuffer )
	{
		glDeleteRenderbuffers(1, &_depthRenderBuffer);
	}
	
	[super dealloc];
}

- (void)resizeFromLayer:(CAEAGLLayer*)layer
{
}

- (void)render
{
}

@end
