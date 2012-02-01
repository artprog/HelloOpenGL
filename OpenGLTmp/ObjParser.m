//
//  ObjParser.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 19.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "ObjParser.h"
#import "MtlParser.h"

static NSInteger defaultVectorCapacity = 4096;

@interface ObjParser ()
- (void)readVertex:(char*)line;
- (void)readTextureCoords:(char*)line;
- (void)readNormalVector:(char*)line;
- (void)readTriangles:(char*)line;
- (void)parseMtl:(char*)line;
- (void)useMtl:(char*)line;
@end

@implementation ObjParser

- (id)initWithFile:(NSString*)path
{
	if ( (self = [super init]) )
	{
		_filePath = [path copy];
		_vertices.reserve(defaultVectorCapacity);
		_textCoords.reserve(defaultVectorCapacity);
		_normalVectors.resize(defaultVectorCapacity);
		_meshes.reserve(defaultVectorCapacity);
	}
	return self;
}

- (void)dealloc
{
	[_filePath release];
	[_mtlParser release];
	
	[super dealloc];
}

- (void)parse
{	
	FILE *file = fopen([_filePath cStringUsingEncoding:NSUTF8StringEncoding], "r");
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
		if ( strcmp(identifier, "mtllib") == 0 )
		{
			[self parseMtl:line];
			continue;
		}
		if ( strcmp(identifier, "usemtl") == 0 )
		{
			[self useMtl:line];
			continue;
		}
	}
	if ( _meshes.size() )
	{
		Mesh &currentMesh = _meshes.back();
		currentMesh.indicesCount = _indices.size()-currentMesh.offset;
	}
	fclose(file);
}

- (TriangleVertex*)triangleVertices
{
	return &_vertices[0];
}

- (NSUInteger)triangleVerticesCount
{
	return _vertices.size();
}

- (Mesh*)meshes
{
	return &_meshes[0];
}

- (NSUInteger)meshesCount
{
	return _meshes.size();
}

- (GLushort*)indices
{
	return &_indices[0];
}

- (NSUInteger)indicesCount
{
	return _indices.size();
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

- (void)parseMtl:(char*)line
{
	char mtlName[256];
	sscanf(line, "mtllib %s", mtlName);
	if ( strlen(mtlName) > 0 )
	{
		NSString *mtlNameStr = [NSString stringWithCString:mtlName encoding:NSUTF8StringEncoding];
		NSString *mtlPath = [[_filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:mtlNameStr];
		[_mtlParser release];
		_mtlParser = [[MtlParser alloc] initWithFile:mtlPath];
		[_mtlParser parse];
	}
}

- (void)useMtl:(char*)line
{
	char mtlName[256];
	sscanf(line, "usemtl %s", mtlName);
	if ( strlen(mtlName) > 0 )
	{
		NSString *mtlNameStr = [NSString stringWithCString:mtlName encoding:NSUTF8StringEncoding];
		NSValue *materialValue = nil;
		materialValue = [_mtlParser.materials objectForKey:mtlNameStr];
		Material material;
		[materialValue getValue:&material];
		Mesh mesh;
		mesh.material = material;
		mesh.offset = _indices.size();
		if ( _meshes.size() )
		{
			Mesh &currentMesh = _meshes.back();
			currentMesh.indicesCount = mesh.offset-currentMesh.offset;
		}
		_meshes.push_back(mesh);
	}
}

@end
