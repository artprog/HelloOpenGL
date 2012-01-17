//
//  Vertex3D.h
//  OpenGLTmp
//
//  Created by SMT Software on 12.01.2012.
//  Copyright (c) 2012 SMTSoftware. All rights reserved.
//

#import "Color.h"

typedef struct
{
	GLfloat x;
	GLfloat y;
	GLfloat z;
} Vertex3D;

Vertex3D Vertex3DMake(GLfloat x, GLfloat y, GLfloat z);