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

Vertex3D Vertex3DNormalize(Vertex3D vertex)
{
	CGFloat mag = Vertex3DMagnitude(vertex);
	return Vertex3DMake(vertex.x/mag, vertex.y/mag, vertex.z/mag);
}

GLfloat Vertex3DMagnitude(Vertex3D vertex)
{
	return sqrtf(vertex.x*vertex.x + vertex.y*vertex.y + vertex.z*vertex.z);
}

Vertex3D Vertex3DCrossProduct(Vertex3D v1, Vertex3D v2)
{
	Vertex3D vertex;
	
	vertex.x = v1.y*v2.z - v1.z*v2.y;
	vertex.y = v1.z*v2.x - v1.x*v2.z;
	vertex.z = v1.x*v2.y - v1.y*v2.x;
	
	return vertex;
}