//
//  APOpenGLObject.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 12.07.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

@class APOpenGLParser;
@class APOpenGLProgram;

@interface APOpenGLObject : NSObject
{
	@private
	BOOL _built;
	
	GLuint _vertexBuffer;
	APOpenGLProgram *_program;
	
	GLuint _positionSlot;
	GLuint _textCoordSlot;
	
	GLuint _projectionUniformSlot;
	GLuint _ambientUniformSlot;
	GLuint _diffuseUniformSlot;
	GLuint _textureAvailableUniformSlot;
	GLuint _textureUniformSlot;
	
//	CGFloat _cameraAngleY;
//	CGFloat _cameraAngleX;
//	NSMutableSet *_drawingElements;
}

- (APOpenGLParser*)createParser;

- (BOOL)isBuilt;
- (void)build;
- (void)render;

@end
