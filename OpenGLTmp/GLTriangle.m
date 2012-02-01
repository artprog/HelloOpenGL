//
//  GLTriangle.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 13.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "GLTriangle.h"
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
		_drawingElements = [[NSMutableSet alloc] init];
		
		ObjParser *objParser = [[ObjParser alloc] initWithFile:path];
		NSLog(@"a");
		[objParser parse];
		NSLog(@"b");
		
		NSString *vertex = [[NSBundle mainBundle] pathForResource:@"VertexShader" ofType:@"glsl"];
		NSString *fragment = [[NSBundle mainBundle] pathForResource:@"FragmentShader" ofType:@"glsl"];
		_program = [[GLProgram alloc] initWithVertexShaderFile:vertex fragmentShaderFile:fragment];
		[_program addAttribute:@"position"];
		[_program addAttribute:@"sourceTextCoord"];
		if ( ![_program link] )
		{
			NSLog(@"Error while linking OpenGL program: \"%@\"!!!", [_program programLog]);
		}
		
		_positionSlot = [_program attributeIndex:@"position"];
		_textCoordSlot = [_program attributeIndex:@"sourceTextCoord"];
		
		_projectionUniformSlot = [_program uniformIndex:@"projection"];
		_ambientUniformSlot = [_program uniformIndex:@"ambientColor"];
		_diffuseUniformSlot = [_program uniformIndex:@"diffuseColor"];
		_textureAvailableUniformSlot = [_program uniformIndex:@"textureAvailable"];
		_textureUniformSlot = [_program uniformIndex:@"texture"];
		
		glEnableVertexAttribArray(_positionSlot);
		glEnableVertexAttribArray(_textCoordSlot);
		
		glEnableVertexAttribArray(_projectionUniformSlot);
		glEnableVertexAttribArray(_ambientUniformSlot);
		glEnableVertexAttribArray(_diffuseUniformSlot);
		
		glGenBuffers(1, &_vertexBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
		glBufferData(GL_ARRAY_BUFFER, sizeof(TriangleVertex)*[objParser triangleVerticesCount], [objParser triangleVertices], GL_STATIC_DRAW);
		
		GLushort *indices = [objParser indices];
		Mesh *meshes = [objParser meshes];
		NSUInteger meshesCount = [objParser meshesCount];
		Mesh mesh;
		for (int i=0; i<meshesCount; ++i)
		{
			mesh = meshes[i];
			DrawingElement drawingElement;
			drawingElement.indexCount = mesh.indicesCount;
			drawingElement.material = mesh.material;
			glGenBuffers(1, &drawingElement.indexBuffer);
			glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, drawingElement.indexBuffer);
			glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLushort)*drawingElement.indexCount, indices+mesh.offset, GL_STATIC_DRAW);
			
			if ( strlen(drawingElement.material.map_Kd) > 0 )
			{
				NSString *mapKdStr = [NSString stringWithCString:drawingElement.material.map_Kd encoding:NSUTF8StringEncoding];
				CGImageRef spriteImage = [UIImage imageWithContentsOfFile:[[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:mapKdStr]].CGImage;
				size_t width = CGImageGetWidth(spriteImage);
				size_t height = CGImageGetHeight(spriteImage);
				GLubyte *spriteData = (GLubyte*)calloc(width*height*4, sizeof(GLubyte));
				CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);    
				CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
				CGContextRelease(spriteContext);
				
				glGenTextures(1, &drawingElement.textureBuffer);
				glBindTexture(GL_TEXTURE_2D, drawingElement.textureBuffer);
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
				glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
				free(spriteData);
			}
			
			[_drawingElements addObject:[NSValue valueWithBytes:&drawingElement objCType:@encode(DrawingElement)]];
		}
		
		[objParser release];
	}
	return self;
}

- (void)dealloc
{	
	DrawingElement drawingElement;
	for (NSValue *drawingElementValue in _drawingElements)
	{
		[drawingElementValue getValue:&drawingElement];
		glDeleteBuffers(1, &drawingElement.indexBuffer);
		if ( strlen(drawingElement.material.map_Kd) > 0 )
		{
			glDeleteTextures(1, &drawingElement.textureBuffer);
		}
	}
	glDeleteBuffers(1, &_vertexBuffer);
	[_program release];
	[_drawingElements release];
	
	[super dealloc];
}

- (void)use
{
	glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
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
	
	glUniformMatrix4fv(_projectionUniformSlot, 1, GL_FALSE, (const GLfloat*)(&projection));
	
	glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(TriangleVertex), 0);
	glVertexAttribPointer(_textCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(TriangleVertex), (GLvoid*)(sizeof(Vertex)));
	
	DrawingElement drawingElement;
	for (NSValue *drawingElementValue in _drawingElements)
	{
		[drawingElementValue getValue:&drawingElement];
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, drawingElement.indexBuffer);
		glUniform1i(_ambientUniformSlot, 1);
		glUniform4f(_ambientUniformSlot, drawingElement.material.ambient.red, drawingElement.material.ambient.green, drawingElement.material.ambient.blue, drawingElement.material.ambient.alpha);
		glUniform4f(_diffuseUniformSlot, drawingElement.material.diffuse.red, drawingElement.material.diffuse.green, drawingElement.material.diffuse.blue, drawingElement.material.diffuse.alpha);
		if ( strlen(drawingElement.material.map_Kd) > 0 )
		{
			glUniform1i(_textureAvailableUniformSlot, GL_TRUE);
			glActiveTexture(GL_TEXTURE0);
			glBindTexture(GL_TEXTURE_2D, drawingElement.textureBuffer);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
			glUniform1i(_textureUniformSlot, 0);
		}
		else
		{
			glUniform1i(_textureAvailableUniformSlot, GL_FALSE);
		}
		glDrawElements(GL_TRIANGLES, drawingElement.indexCount, GL_UNSIGNED_SHORT, 0);
	}
}

@end
