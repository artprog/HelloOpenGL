//
//  GLModel.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 31.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#include <string>
#include <vector>

typedef struct
{
	GLfloat x;
	GLfloat y;
} Vector2D;

Vector2D Vector2DMake(GLfloat x, GLfloat y);

typedef struct
{
	GLfloat x;
	GLfloat y;
	GLfloat z;
} Vector3D;

Vector3D Vector3DMake(GLfloat x, GLfloat y, GLfloat z);
Vector3D Vector3DNormalize(Vector3D vector);
GLfloat Vector3DMagnitude(Vector3D vector);
Vector3D Vector3DCrossProduct(Vector3D v1, Vector3D v2);

typedef struct
{
    GLfloat x;
	GLfloat y;
	GLfloat z;
} Vertex;

typedef struct
{
	Vertex vertex;
	Vector2D textureCoords;
	Vector3D vertexNormal;
} TriangleVertex;

typedef struct
{
	GLfloat red;
	GLfloat green;
	GLfloat blue;
	GLfloat alpha;
} Color;

Color ColorMake(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);

typedef struct
{
	GLfloat Ns;
	Color ambient;
	Color diffuse;
	Color specular;
	Color emissive;
    GLfloat shininess;
	GLfloat Ni;
	GLfloat d;
	GLfloat illum;
	char map_Kd[256];
	char name[256];
} Material;

typedef struct
{
    Material material;
	GLuint offset;
	GLuint indicesCount;
} Mesh;