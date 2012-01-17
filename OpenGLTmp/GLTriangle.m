//
//  GLTriangle.m
//  OpenGLTmp
//
//  Created by SMT Software on 13.01.2012.
//  Copyright (c) 2012 SMTSoftware. All rights reserved.
//

#import "GLTriangle.h"
#import "Vertex3D.h"
#import "Triangle3D.h"
#import "Color.h"
#import "GLProgram.h"
#import "Matrix.h"
#import <QuartzCore/QuartzCore.h>

typedef struct
{
	Vertex3D vertex;
	Color color;
} Vertex;

@implementation GLTriangle

@synthesize projectionAngleX = _projectionAngleX;
@synthesize projectionAngleY = _projectionAngleY;

- (id)init
{
	if ( (self = [super init]) )
	{
		Vertex3D vertex1 = Vertex3DMake(0.0, 1.0, 0.5f);
		Vertex3D vertex2 = Vertex3DMake(1.0, 0.0, 0.5f);
		Vertex3D vertex3 = Vertex3DMake(-1.0, 0.0, 0.5f);
		Vertex3D vertex4 = Vertex3DMake(0.0, 1.0, -0.5f);
		Vertex3D vertex5 = Vertex3DMake(1.0, 0.0, -0.5f);
		Vertex3D vertex6 = Vertex3DMake(-1.0, 0.0, -0.5f);
		Color colorBlue = ColorMake(0, 0, 1, 1);
		Color colorGreen = ColorMake(0, 1, 0, 1);
		
		Vertex vertices[] = {
			{vertex1, colorBlue},
			{vertex2, colorBlue},
			{vertex3, colorBlue},
			{vertex4, colorGreen},
			{vertex5, colorGreen},
			{vertex6, colorGreen}
		};
		
		GLubyte indices[] = {
			// front
			2, 1, 0,
			// back
			3, 4, 5,
			// left
			0, 1, 4,
			4, 0, 3,
			// right
			0, 2, 5,
			5, 3, 0,
			// bottom
			2, 1, 5,
			5, 1, 4
		};
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
		_rotationXSlot = [_program uniformIndex:@"rotationX"];
		_rotationYSlot = [_program uniformIndex:@"rotationY"];
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
	Matrix projection = MatrixMake(-2.f, 2.f, -2.f, 2.f, -2.f, 2.f);
	glUniformMatrix4fv(_projectionSlot, 1, GL_FALSE, (const GLfloat*)(&projection));

	Matrix rotationX = MatrixMakeRotationX(self.projectionAngleX);
	glUniformMatrix4fv(_rotationXSlot, 1, GL_FALSE, (const GLfloat*)(&rotationX));
	
	Matrix rotationY = MatrixMakeRotationY(self.projectionAngleY);
	glUniformMatrix4fv(_rotationYSlot, 1, GL_FALSE, (const GLfloat*)(&rotationY));
	
	glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*)sizeof(Vertex3D));
    glDrawElements(GL_TRIANGLES, _indexCount, GL_UNSIGNED_BYTE, 0);
}

@end
