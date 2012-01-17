//
//  GLTriangle.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 13.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

@class GLProgram;

@interface GLTriangle : NSObject
{
	@private
	GLuint _vertexBuffer;
	GLuint _indexBuffer;
	GLProgram *_program;
	GLuint _indexCount;
	GLuint _positionSlot;
	GLuint _colorSlot;
	GLuint _projectionSlot;
	GLuint _rotationXSlot;
	GLuint _rotationYSlot;
	CGFloat _projectionAngleX;
	CGFloat _projectionAngleY;
}

@property CGFloat projectionAngleX;
@property CGFloat projectionAngleY;

- (void)use;
- (void)render:(GLfloat)width height:(GLfloat)height;

@end
