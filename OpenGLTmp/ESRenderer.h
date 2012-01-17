//
//  ESRenderer.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 10.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

@class EAGLContext;
@class CAEAGLLayer;

@protocol ESRenderer <NSObject>
- (void)render;
- (void)resizeFromLayer:(CAEAGLLayer*)layer;
@end

@interface ESRenderer : NSObject <ESRenderer>
{
	@protected
	EAGLContext *_context;
	GLuint _colorRenderBuffer;
	GLuint _frameBuffer;
	GLuint _depthRenderBuffer;
	GLint _width;
	GLint _height;
	CGFloat _projectionAgleX;
	CGFloat _projectionAngleY;
}

- (void)render;
- (void)resizeFromLayer:(CAEAGLLayer*)layer;

@end
