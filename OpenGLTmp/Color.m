//
//  Color.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 12.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
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