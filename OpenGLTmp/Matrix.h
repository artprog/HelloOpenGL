//
//  Matrix.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 16.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

typedef struct
{
	GLfloat _11;
	GLfloat _21;
	GLfloat _31;
	GLfloat _41;
	GLfloat _12;
	GLfloat _22;
	GLfloat _32;
	GLfloat _42;
	GLfloat _13;
	GLfloat _23;
	GLfloat _33;
	GLfloat _43;
	GLfloat _14;
	GLfloat _24;
	GLfloat _34;
	GLfloat _44;
} Matrix;

typedef struct
{
	GLfloat _x;
	GLfloat _y;
	GLfloat _z;
	GLfloat _w;
} Quaternion;

Matrix MatrixMakeOrtographicProjection(GLfloat left, GLfloat right, GLfloat bottom, GLfloat top, GLfloat near, GLfloat far);
Matrix MatrixMakePerspectiveProjection(GLfloat near, GLfloat far, GLfloat angleOfView, GLfloat aspectRatio);
Matrix MatrixMakeLookAt(GLfloat eyeX, GLfloat eyeY, GLfloat eyeZ, GLfloat centerX, GLfloat centerY, GLfloat centerZ, GLfloat upX, GLfloat upY, GLfloat upZ);
Matrix MatrixMakeIdentity(void);
Matrix MatrixMakeTranslation(GLfloat x, GLfloat y, GLfloat z);
Matrix MatrixMakeRotationX(GLfloat angle);
Matrix MatrixMakeRotationY(GLfloat angle);
Matrix MatrixMakeRotationZ(GLfloat angle);
Matrix MatrixMakeRotationYX(CGFloat angleY, CGFloat angleX);
Matrix MatrixMultiply(Matrix m1, Matrix m2);
Matrix MatrixFromQuaternion(Quaternion q);
Quaternion QuaternionMakeIdentity(void);
Quaternion QuaternionMakeEulerAngles(GLfloat y, GLfloat z, GLfloat x);
Quaternion QuaternionMultiply(Quaternion q1, Quaternion q2);
Quaternion QuaternionInverse(Quaternion q);