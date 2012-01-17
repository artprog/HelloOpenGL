//
//  Color.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 12.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

typedef struct
{
	GLfloat red;
	GLfloat green;
	GLfloat blue;
	GLfloat alpha;
} Color;

Color ColorMake(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);