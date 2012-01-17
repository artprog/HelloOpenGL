//
//  Vertex3D.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 12.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "Color.h"

typedef struct
{
	GLfloat x;
	GLfloat y;
	GLfloat z;
} Vertex3D;

Vertex3D Vertex3DMake(GLfloat x, GLfloat y, GLfloat z);