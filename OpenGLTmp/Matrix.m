//
//  Matrix.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 16.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "Matrix.h"

Matrix MatrixMakeOrtographicProjection(GLfloat left, GLfloat right, GLfloat bottom, GLfloat top, GLfloat near, GLfloat far)
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

Matrix MatrixMakePerspectiveProjection(GLfloat near, GLfloat far, GLfloat angleOfView, GLfloat aspectRatio)
{
	GLfloat size = near * tanf(angleOfView/2.f);
	GLfloat left = -size;
	GLfloat right = size;
	GLfloat bottom = -size/aspectRatio;
	GLfloat top = size/aspectRatio;

	Matrix matrix = MatrixMakeIdentity();
	
	matrix._11 = 2.f * near / (right - left);
	matrix._22 = 2.f * near / (top - bottom);
	matrix._13 = (right + left) / (right - left);
	matrix._23 = (top + bottom) / (top - bottom);
	matrix._33 = -(far + near) / (far - near);
	matrix._43 = -1.f;
	matrix._14 = 0.f;
	matrix._24 = 0.f;
	matrix._34 = -(2.f * far * near) / (far - near);
	matrix._44 = 0.f;
	
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

Matrix MatrixMultiply(Matrix m1, Matrix m2)
{
	Matrix matrix;
	
	// Fisrt Column
    matrix._11 = m1._11*m2._11 + m1._12*m2._21 + m1._13*m2._31 + m1._14*m2._41;
    matrix._21 = m1._21*m2._11 + m1._22*m2._21 + m1._23*m2._31 + m1._24*m2._41;
    matrix._31 = m1._31*m2._11 + m1._32*m2._21 + m1._33*m2._31 + m1._34*m2._41;
    matrix._41 = m1._41*m2._11 + m1._42*m2._21 + m1._43*m2._31 + m1._44*m2._41;
	
    // Second Column
    matrix._12 = m1._11*m2._12 + m1._12*m2._22 + m1._13*m2._32 + m1._14*m2._42;
    matrix._22 = m1._21*m2._12 + m1._22*m2._22 + m1._23*m2._32 + m1._24*m2._42;
    matrix._32 = m1._31*m2._12 + m1._32*m2._22 + m1._33*m2._32 + m1._34*m2._42;
    matrix._42 = m1._41*m2._12 + m1._42*m2._22 + m1._43*m2._32 + m1._44*m2._42;
	
    // Third Column
    matrix._13 = m1._11*m2._13 + m1._12*m2._23 + m1._13*m2._33 + m1._14*m2._43;
    matrix._23 = m1._21*m2._13 + m1._22*m2._23 + m1._23*m2._33 + m1._24*m2._43;
    matrix._33 = m1._31*m2._13 + m1._32*m2._23 + m1._33*m2._33 + m1._34*m2._43;
    matrix._43 = m1._41*m2._13 + m1._42*m2._23 + m1._43*m2._33 + m1._44*m2._43;
	
    // Fourth Column
    matrix._14 = m1._11*m2._14 + m1._12*m2._24 + m1._13*m2._34 + m1._14*m2._44;
    matrix._24 = m1._21*m2._14 + m1._22*m2._24 + m1._23*m2._34 + m1._24*m2._44;
    matrix._34 = m1._31*m2._14 + m1._32*m2._24 + m1._33*m2._34 + m1._34*m2._44;
    matrix._44 = m1._41*m2._14 + m1._42*m2._24 + m1._43*m2._34 + m1._44*m2._44;
	return matrix;
}

Matrix MatrixFromQuaternion(Quaternion q)
{
	Matrix matrix;
	
	// First Column
    matrix._11 = 1 - 2 * (q._y * q._y + q._z * q._z);
    matrix._21 = 2 * (q._x * q._y + q._z * q._w);
    matrix._31 = 2 * (q._x * q._z - q._y * q._w);
    matrix._41 = 0;
	
    // Second Column
    matrix._12 = 2 * (q._x * q._y - q._z * q._w);
    matrix._22 = 1 - 2 * (q._x * q._x + q._z * q._z);
    matrix._32 = 2 * (q._z * q._y + q._x * q._w);
    matrix._42 = 0;
	
    // Third Column
    matrix._13 = 2 * (q._x * q._z + q._y * q._w);
    matrix._23 = 2 * (q._y * q._z - q._x * q._w);
    matrix._33 = 1 - 2 * (q._x * q._x + q._y * q._y);
    matrix._43 = 0;
	
    // Fourth Column
    matrix._14 = 0;
    matrix._24 = 0;
    matrix._34 = 0;
    matrix._44 = 1;
	
	return matrix;
}

Quaternion QuaternionMakeIdentity(void)
{
	Quaternion quaternion = {0, 0, 0, 1};
	return quaternion;
}

Quaternion QuaternionMakeEulerAngles(GLfloat y, GLfloat z, GLfloat x)
{
	Quaternion quaternion;
	
    GLfloat sY = sinf(y * 0.5f);
    GLfloat cY = cosf(y * 0.5f);
    GLfloat sZ = sinf(z * 0.5f);
    GLfloat cZ = cosf(z * 0.5f);
    GLfloat sX = sinf(x * 0.5f);
    GLfloat cX = cosf(x * 0.5f);
	
    // Formula to construct a new Quaternion based on Euler Angles.
    quaternion._w = cY * cZ * cX - sY * sZ * sX;
    quaternion._x = sY * sZ * cX + cY * cZ * sX;
    quaternion._y = sY * cZ * cX + cY * sZ * sX;
    quaternion._z = cY * sZ * cX - sY * cZ * sX;
	
	return quaternion;
}

Quaternion QuaternionMultiply(Quaternion q1, Quaternion q2)
{
	Quaternion quaternion;
	
	quaternion._w = q1._w * q2._w - q1._x * q2._x - q1._y * q2._y - q1._z * q2._z;
    quaternion._x = q1._w * q2._x + q1._x * q2._w + q1._y * q2._z - q1._z * q2._y;
    quaternion._y = q1._w * q2._y - q1._x * q2._z + q1._y * q2._w + q1._z * q2._x;
    quaternion._z = q1._w * q2._z + q1._x * q2._y - q1._y * q2._x + q1._z * q2._w;
	
	return quaternion;
}

Quaternion QuaternionInverse(Quaternion q)
{
	Quaternion quaternion;
	
	quaternion._x *= -1;
	quaternion._y *= -1;
	quaternion._z *= -1;
	
	return quaternion;
}