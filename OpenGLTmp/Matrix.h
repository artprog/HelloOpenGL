//
//  Matrix.h
//  OpenGLTmp
//
//  Created by SMT Software on 16.01.2012.
//  Copyright (c) 2012 SMTSoftware. All rights reserved.
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

Matrix MatrixMake(GLfloat left, GLfloat right, GLfloat bottom, GLfloat top, GLfloat near, GLfloat far);
Matrix MatrixMakeIdentity(void);
Matrix MatrixMakeTranslation(GLfloat x, GLfloat y, GLfloat z);
Matrix MatrixMakeRotationX(GLfloat angle);
Matrix MatrixMakeRotationY(GLfloat angle);
Matrix MatrixMakeRotationZ(GLfloat angle);
Matrix MatrixMakeRotationYX(CGFloat angleY, CGFloat angleX);