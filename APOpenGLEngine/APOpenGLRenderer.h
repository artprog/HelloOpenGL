//
//  APOpenGLRenderer.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 04.07.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

@class CAEAGLLayer;

@interface APOpenGLRenderer : NSObject
{
	@private
	dispatch_queue_t _mutexQueue;
	BOOL _rendering;
	CGFloat _refreshRate;
	CADisplayLink *_displayLink;
	
	EAGLContext *_context;
	GLint _width;
	GLint _height;
	GLuint _colorRenderBuffer;
	GLuint _frameBuffer;
	GLuint _depthRenderBuffer;
	
}

@property (nonatomic, readonly, getter=isRendering) BOOL rendering;
@property (nonatomic) CGFloat refreshRate;

- (void)renderSingleFrame;
- (void)startRendering;
- (void)stopRendering;

- (void)resizeFromLayer:(CAEAGLLayer*)layer;

@end
