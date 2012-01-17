//
//  ES2Renderer.h
//  OpenGLTmp
//
//  Created by SMT Software on 10.01.2012.
//  Copyright (c) 2012 SMTSoftware. All rights reserved.
//

#import "ESRenderer.h"

@class GLTriangle;

@interface ES2Renderer : ESRenderer
{
	@private
	GLTriangle *_triangle;
}

@property (nonatomic, readonly) GLTriangle *triangle;

@end
