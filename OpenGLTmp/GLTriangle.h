//
//  GLTriangle.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 13.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "GLModel.h"

@class GLProgram;

typedef struct
{
	Material material;
	GLuint indexBuffer;
	GLuint indexCount;
	GLuint textureBuffer;
} DrawingElement;

@interface GLTriangle : NSObject
{
	@private
	GLuint _vertexBuffer;
	GLProgram *_program;
	
	GLuint _positionSlot;
	GLuint _textCoordSlot;
	
	GLuint _projectionUniformSlot;
	GLuint _ambientUniformSlot;
	GLuint _diffuseUniformSlot;
	GLuint _textureAvailableUniformSlot;
	GLuint _textureUniformSlot;
	
	CGFloat _cameraAngleY;
	CGFloat _cameraAngleX;
	NSMutableSet *_drawingElements;
}

@property CGFloat cameraAngleX;
@property CGFloat cameraAngleY;

- (void)use;
- (void)render:(GLfloat)width height:(GLfloat)height;

@end
