//
//  APOpenGLDefaultObject.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 24.07.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "APOpenGLObject.h"

@interface APOpenGLDefaultObject : APOpenGLObject
{
	@private
	GLuint _positionSlot;
	GLuint _textCoordSlot;
	
	GLuint _projectionUniformSlot;
	GLuint _ambientUniformSlot;
	GLuint _diffuseUniformSlot;
	GLuint _textureAvailableUniformSlot;
	GLuint _textureUniformSlot;
}

@end
