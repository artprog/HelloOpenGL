//
//  GLTriangle.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 13.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "GLTriangle.h"
#import "Vertex3D.h"
#import "Triangle3D.h"
#import "Color.h"
#import "GLProgram.h"
#import "Matrix.h"
#import <QuartzCore/QuartzCore.h>
#import "ObjParser.h"

typedef struct
{
	Vertex3D vertex;
	Color color;
} Vertex;

@implementation GLTriangle

@synthesize cameraAngleY = _cameraAngleY;
@synthesize cameraAngleX = _cameraAngleX;

- (id)init
{
	if ( (self = [super init]) )
	{
//		Vertex3D vertex1 = Vertex3DMake(0.0, 1.0, 0.5f);
//		Vertex3D vertex2 = Vertex3DMake(1.0, 0.0, 0.5f);
//		Vertex3D vertex3 = Vertex3DMake(-1.0, 0.0, 0.5f);
//		Vertex3D vertex4 = Vertex3DMake(0.0, 1.0, -0.5f);
//		Vertex3D vertex5 = Vertex3DMake(1.0, 0.0, -0.5f);
//		Vertex3D vertex6 = Vertex3DMake(-1.0, 0.0, -0.5f);
//		Color colorBlue = ColorMake(0, 0, 1, 1);
		Color colorGreen = ColorMake(0, 1, 0, 1);
//		
//		Vertex vertices[] = {
//			{vertex1, colorBlue},
//			{vertex2, colorBlue},
//			{vertex3, colorBlue},
//			{vertex4, colorGreen},
//			{vertex5, colorGreen},
//			{vertex6, colorGreen}
//		};
//		
//		GLubyte indices[] = {
//			// front
//			2, 1, 0,
//			// back
//			3, 4, 5,
//			// left
//			0, 1, 4,
//			4, 0, 3,
//			// right
//			0, 2, 5,
//			5, 3, 0,
//			// bottom
//			2, 1, 5,
//			5, 1, 4
//		};
		NSString *path = [[NSBundle mainBundle] pathForResource:@"Chair_Conv" ofType:@"obj"];
		ObjParser *objParser = [[ObjParser alloc] initWithFile:path];
		[objParser parse];
		NSArray *verticesArray = [objParser vertices];
		NSArray *indicesArray = [objParser indices];
		Vertex vertices[verticesArray.count];
		Vertex3D vertex3D;
		Vertex vertexTmp;
		NSValue *value;
		for (NSInteger i=0; i<verticesArray.count; ++i)
		{
			value = [verticesArray objectAtIndex:i];
			[value getValue:&vertex3D];
			vertexTmp.vertex = vertex3D;
			vertexTmp.color = colorGreen;
			vertices[i] = vertexTmp;
		}
		GLushort indices[indicesArray.count];
		for (NSInteger i=0; i<indicesArray.count; ++i)
		{
			indices[i] = [[indicesArray objectAtIndex:i] unsignedShortValue];
		}
		[objParser release];
		_indexCount = sizeof(indices)/sizeof(indices[0]);
		
		NSString *vertex = [[NSBundle mainBundle] pathForResource:@"VertexShader" ofType:@"glsl"];
		NSString *fragment = [[NSBundle mainBundle] pathForResource:@"FragmentShader" ofType:@"glsl"];
		_program = [[GLProgram alloc] initWithVertexShaderFile:vertex fragmentShaderFile:fragment];
		[_program addAttribute:@"position"];
		[_program addAttribute:@"sourceColor"];
		if ( ![_program link] )
		{
			NSLog(@"Error while linking OpenGL program!!!");
		}
		
		_positionSlot = [_program attributeIndex:@"position"];
		_colorSlot = [_program attributeIndex:@"sourceColor"];
		_projectionSlot = [_program uniformIndex:@"projection"];
		glEnableVertexAttribArray(_positionSlot);
		glEnableVertexAttribArray(_colorSlot);
		
		glGenBuffers(1, &_vertexBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
		glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
		
		glGenBuffers(1, &_indexBuffer);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
	}
	return self;
}

- (void)dealloc
{
	GLuint buffers[] = {_vertexBuffer, _indexBuffer};
	glDeleteBuffers(2, buffers);
	
	[_program release];
	
	[super dealloc];
}

- (void)use
{
	glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
	[_program use];
}

- (void)render:(GLfloat)width height:(GLfloat)height
{
//	Matrix projection = MatrixMakeOrtographicProjection(-1.5f, 1.5f, -1.5f, 1.5f, -1.5f, 1.5f);
	Matrix projection = MatrixMakePerspectiveProjection(3.f, 7.f, M_PI_4, width/height);
	
	Matrix lookAt = MatrixMakeLookAt(5*cosf(self.cameraAngleX)*sinf(self.cameraAngleY), 5*sinf(self.cameraAngleX), 5*cosf(self.cameraAngleX)*cosf(self.cameraAngleY), 0, 0, 0, 0, cosf(self.cameraAngleX)>0?1:-1, 0);
	
	projection = MatrixMultiply(projection, lookAt);
	
	Matrix scale = MatrixMakeScale(2);
	projection = MatrixMultiply(projection, scale);
	
	glUniformMatrix4fv(_projectionSlot, 1, GL_FALSE, (const GLfloat*)(&projection));
	
	glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*)sizeof(Vertex3D));
    glDrawElements(GL_TRIANGLES, _indexCount, GL_UNSIGNED_SHORT, 0);
}

@end
