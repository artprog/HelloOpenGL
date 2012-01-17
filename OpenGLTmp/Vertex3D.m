//
//  Vertex3D.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 12.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "Vertex3D.h"

Vertex3D Vertex3DMake(GLfloat x, GLfloat y, GLfloat z)
{
	Vertex3D vertex;
	vertex.x = x;
	vertex.y = y;
	vertex.z = z;
	return vertex;
}
