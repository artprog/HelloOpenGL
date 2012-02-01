//
//  GLModel.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 31.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "GLModel.h"

Vector2D Vector2DMake(GLfloat x, GLfloat y)
{
	Vector2D vector = {x, y};
	return vector;
}

Vector3D Vector3DMake(GLfloat x, GLfloat y, GLfloat z)
{
	Vector3D vertex;
	vertex.x = x;
	vertex.y = y;
	vertex.z = z;
	return vertex;
}

Vector3D Vector3DNormalize(Vector3D vector)
{
	CGFloat mag = Vector3DMagnitude(vector);
	return Vector3DMake(vector.x/mag, vector.y/mag, vector.z/mag);
}

GLfloat Vector3DMagnitude(Vector3D vector)
{
	return sqrtf(vector.x*vector.x + vector.y*vector.y + vector.z*vector.z);
}

Vector3D Vector3DCrossProduct(Vector3D v1, Vector3D v2)
{
	Vector3D vector;
	
	vector.x = v1.y*v2.z - v1.z*v2.y;
	vector.y = v1.z*v2.x - v1.x*v2.z;
	vector.z = v1.x*v2.y - v1.y*v2.x;
	
	return vector;
}

Color ColorMake(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha)
{
	Color color;
	color.red = red;
	color.green = green;
	color.blue = blue;
	color.alpha = alpha;
	return color;
}