//
//  Color.h
//  OpenGLTmp
//
//  Created by SMT Software on 12.01.2012.
//  Copyright (c) 2012 SMTSoftware. All rights reserved.
//

typedef struct
{
	GLfloat red;
	GLfloat green;
	GLfloat blue;
	GLfloat alpha;
} Color;

Color ColorMake(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);