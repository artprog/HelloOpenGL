//
//  Matrix.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 16.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "Matrix.h"

Matrix MatrixMake(GLfloat left, GLfloat right, GLfloat bottom, GLfloat top, GLfloat near, GLfloat far)
{
	Matrix matrix = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1};
	matrix._11 = 2.f/(right-left);
	matrix._22 = 2.f/(top-bottom);
	matrix._33 = -2.f/(far-near);
	matrix._14 = -1.f*(right+left)/(right-left);
	matrix._24 = -1.f*(top+bottom)/(top-bottom);
	matrix._34 = -1.f*(far+near)/(far-near);
	
	return matrix;
}

Matrix MatrixMakeIdentity(void)
{
	Matrix matrix = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1};
	return matrix;
}

Matrix MatrixMakeTranslation(GLfloat x, GLfloat y, GLfloat z)
{
	Matrix matrix = MatrixMakeIdentity();
	matrix._14 = x;
	matrix._24 = y;
	matrix._34 = z;
	return matrix;
}

Matrix MatrixMakeRotationX(GLfloat angle)
{
	Matrix matrix = MatrixMakeIdentity();
	matrix._22 = cosf(angle);
	matrix._33 = cosf(angle);
	matrix._23 = sinf(angle);
	matrix._32 = -sinf(angle);
	return matrix;
}

Matrix MatrixMakeRotationY(GLfloat angle)
{
	Matrix matrix = MatrixMakeIdentity();
	matrix._11 = cosf(angle);
	matrix._33 = cosf(angle);
	matrix._13 = -sinf(angle);
	matrix._31 = sinf(angle);
	return matrix;
}

Matrix MatrixMakeRotationZ(GLfloat angle)
{
	Matrix matrix = MatrixMakeIdentity();
	matrix._11 = cosf(angle);
	matrix._22 = cosf(angle);
	matrix._12 = sinf(angle);
	matrix._21 = -sinf(angle);
	return matrix;
}

Matrix MatrixMakeRotationYX(CGFloat angleX, CGFloat angleY)
{
	Matrix matrix = MatrixMakeIdentity();
	
	return matrix;
}