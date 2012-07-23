//
//  APOpenGLParser.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 12.07.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "APOpenGLParser.h"

static const int defaultVectorCapacity = 4096;

@interface APOpenGLParser ()
- (void)readVertex:(char*)line;
- (void)readTextureCoords:(char*)line;
- (void)readNormalVector:(char*)line;
- (void)readTriangles:(char*)line;
@end

@implementation APOpenGLParser

- (id)initWithPath:(NSString *)path
{
	if ( (self = [super init]) )
	{
		_path = [path copy];
		
		_vertices.reserve(defaultVectorCapacity);
		_textCoords.reserve(defaultVectorCapacity);
		_normalVectors.resize(defaultVectorCapacity);
	}
	return self;
}

- (void)dealloc
{
	[_path release];
	
	[super dealloc];
}

- (BOOL)parse:(NSError**)error
{
	FILE *file = fopen([_path cStringUsingEncoding:NSUTF8StringEncoding], "r");
	if ( file == NULL )
	{
		*error = [NSError errorWithDomain:@"APOpenGLParser"
									 code:500
								 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Cannot open obj file", nil), NSLocalizedDescriptionKey, nil]];
		return NO;
	}
	char line[256];
	char identifier[256];
	while ( fgets(line, sizeof(line), file) )
	{
		sscanf(line, "%s", identifier);
		if ( strcmp(identifier, "f") == 0 )
		{
			[self readTriangles:line];
			continue;
		}
		if ( strcmp(identifier, "v") == 0 )
		{
			[self readVertex:line];
			continue;
		}
		if ( strcmp(identifier, "vt") == 0 )
		{
			[self readTextureCoords:line];
			continue;
		}
		if ( strcmp(identifier, "vn") == 0 )
		{
			[self readNormalVector:line];
			continue;
		}
//		if ( strcmp(identifier, "mtllib") == 0 )
//		{
//			[self parseMtl:line];
//			continue;
//		}
//		if ( strcmp(identifier, "usemtl") == 0 )
//		{
//			[self useMtl:line];
//			continue;
//		}
	}
	return YES;
}

#pragma mark -
#pragma mark ObjParser ()

- (void)readVertex:(char*)line
{
	TriangleVertex vertex;
	sscanf(line, "v %f %f %f", &vertex.vertex.x, &vertex.vertex.y, &vertex.vertex.z);
	_vertices.push_back(vertex);
	if ( _vertices.size() >= _vertices.capacity() )
	{
		_vertices.reserve(_vertices.capacity()+defaultVectorCapacity);
	}
}

- (void)readTextureCoords:(char*)line
{
	Vector2D vector;
	sscanf(line, "vt %f %f", &vector.x, &vector.y);
	_textCoords.push_back(vector);
	if ( _textCoords.size() >= _textCoords.capacity() )
	{
		_textCoords.reserve(_textCoords.capacity()+defaultVectorCapacity);
	}
}

- (void)readNormalVector:(char*)line
{
	Vector3D normalVector;
	sscanf(line, "vn %f %f %f", &normalVector.x, &normalVector.y, &normalVector.z);
	_normalVectors.push_back(normalVector);
	if ( _normalVectors.size() >= _normalVectors.capacity() )
	{
		_normalVectors.resize(_normalVectors.capacity()+defaultVectorCapacity);
	}
}

- (void)readTriangles:(char*)line
{
	std::vector<GLuint> polygon;
	int triangleVertexIndex;
	int textureCoordsIndex;
	int vertexNormalIndex;
	
	char *vertex = strtok(line, " "); // first should be "f" sign
	while ( (vertex = strtok(NULL, " ")) )
	{
		sscanf(vertex, "%d/%d/%d", &triangleVertexIndex, &textureCoordsIndex, &vertexNormalIndex);
		triangleVertexIndex -= 1;
		textureCoordsIndex -= 1;
		vertexNormalIndex -= 1;
		_vertices[triangleVertexIndex].textureCoords = _textCoords[textureCoordsIndex];
		_vertices[triangleVertexIndex].vertexNormal = _normalVectors[vertexNormalIndex];
		polygon.push_back(triangleVertexIndex);
	}
	
	int polygonVertices = polygon.size();
	for (int i=1; i<polygonVertices-1; ++i)
	{
		if ( _indices.size()+3 >= _indices.capacity() )
		{
			_indices.reserve(_indices.capacity()+defaultVectorCapacity);
		}
		_indices.push_back(polygon[0]);
		_indices.push_back(polygon[i]);
		_indices.push_back(polygon[i+1]);
	}
}

- (TriangleVertex*)triangleVertices
{
	return &_vertices[0];
}

- (NSUInteger)triangleVerticesCount
{
	return _vertices.size();
}

- (GLushort*)indices
{
	return &_indices[0];
}

- (NSUInteger)indicesCount
{
	return _indices.size();
}

@end
