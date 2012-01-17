//
//  Color.m
//  OpenGLTmp
//
//  Created by SMT Software on 12.01.2012.
//  Copyright (c) 2012 SMTSoftware. All rights reserved.
//

#import "Color.h"

Color ColorMake(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha)
{
	Color color;
	color.red = red;
	color.green = green;
	color.blue = blue;
	color.alpha = alpha;
	return color;
}