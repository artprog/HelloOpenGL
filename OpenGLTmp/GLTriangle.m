//
//  GLTriangle.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 13.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "GLTriangle.h"
#import "Vector2D.h"
#import "Vertex3D.h"
#import "Triangle3D.h"
#import "Color.h"
#import "GLProgram.h"
#import "Matrix.h"
#import <QuartzCore/QuartzCore.h>
#import "ObjParser.h"

@implementation GLTriangle

@synthesize cameraAngleY = _cameraAngleY;
@synthesize cameraAngleX = _cameraAngleX;

- (id)init
{
	if ( (self = [super init]) )
	{
		NSString *path = [[NSBundle mainBundle] pathForResource:@"Chair_Conv" ofType:@"obj"];
		ObjParser *objParser = [[ObjParser alloc] initWithFile:path];
		NSLog(@"a");
		[objParser parse];
		NSLog(@"b");
		_indexCount = [objParser indicesCount];
		
		NSString *vertex = [[NSBundle mainBundle] pathForResource:@"VertexShader" ofType:@"glsl"];
		NSString *fragment = [[NSBundle mainBundle] pathForResource:@"FragmentShader" ofType:@"glsl"];
		_program = [[GLProgram alloc] initWithVertexShaderFile:vertex fragmentShaderFile:fragment];
		[_program addAttribute:@"position"];
		[_program addAttribute:@"sourceColor"];
		[_program addAttribute:@"sourceTextCoord"];
		if ( ![_program link] )
		{
			NSLog(@"Error while linking OpenGL program!!!");
		}
		
		_positionSlot = [_program attributeIndex:@"position"];
		_colorSlot = [_program attributeIndex:@"sourceColor"];
		_textCoordSlot = [_program attributeIndex:@"sourceTextCoord"];
		_projectionSlot = [_program uniformIndex:@"projection"];
		_textureSlot = [_program uniformIndex:@"texture"];
		glEnableVertexAttribArray(_positionSlot);
		glEnableVertexAttribArray(_colorSlot);
		glEnableVertexAttribArray(_textCoordSlot);
		
		glGenBuffers(1, &_vertexBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
		glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex)*[objParser verticesCount], [objParser vertices], GL_STATIC_DRAW);
		
		glGenBuffers(1, &_indexBuffer);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLushort)*_indexCount, [objParser indices], GL_STATIC_DRAW);
		
		//=============
		CGImageRef spriteImage = [UIImage imageNamed:@"Pin_Stripe_3.jpg"].CGImage;
		
		size_t width = CGImageGetWidth(spriteImage);
		size_t height = CGImageGetHeight(spriteImage);
		GLubyte *spriteData = (GLubyte*)calloc(width*height*4, sizeof(GLubyte));
		CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);    
		CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
		CGContextRelease(spriteContext);
		
		glGenTextures(1, &_textureBuffer);
		glBindTexture(GL_TEXTURE_2D, _textureBuffer);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
		
		free(spriteData);
		//============
		
		[objParser release];
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
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*)(sizeof(Vertex3D)+sizeof(Vector2D)));
	
	glVertexAttribPointer(_textCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*)(sizeof(Vertex3D)));
	
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, _textureBuffer);
	glUniform1i(_textureSlot, 0);
	
    glDrawElements(GL_TRIANGLES, _indexCount, GL_UNSIGNED_SHORT, 0);
}

@end
