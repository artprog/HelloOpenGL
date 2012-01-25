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
	GLuint _textureBuffer;
	GLuint _indexBuffer;
	GLProgram *_program;
	GLuint _indexCount;
	GLuint _positionSlot;
	GLuint _colorSlot;
	GLuint _projectionSlot;
	GLuint _textCoordSlot;
	GLuint _textureSlot;
	CGFloat _cameraAngleY;
	CGFloat _cameraAngleX;
}

@property CGFloat cameraAngleX;
@property CGFloat cameraAngleY;

- (void)use;
- (void)render:(GLfloat)width height:(GLfloat)height;

@end
