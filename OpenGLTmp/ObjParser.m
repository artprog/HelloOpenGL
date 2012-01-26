//
//  ObjParser.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 19.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "ObjParser.h"
#import "Vertex3D.h"
#import "MtlParser.h"

static NSInteger defaultVectorCapacity = 4096;

@interface ObjParser ()
- (void)readVertex:(char*)line;
- (void)readIndices:(char*)line;
- (void)readTextureCoords:(char*)line;
- (void)parseMtl:(char*)line;
@end

@implementation ObjParser

- (id)initWithFile:(NSString*)path
{
	if ( (self = [super init]) )
	{
		_filePath = [path copy];
		_vertices = std::vector<Vertex>(defaultVectorCapacity);
		_textCoords = std::vector<Vector2D>(defaultVectorCapacity);
		_indices = std::vector<GLushort>(defaultVectorCapacity);
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
	_vertices.clear();
	_indices.clear();
	
	FILE *file = fopen([_filePath cStringUsingEncoding:NSUTF8StringEncoding], "r");
	char line[256];
	char identifier[256];
	BOOL faceFound = NO;
	while ( fgets(line, sizeof(line), file) )
	{
		sscanf(line, "%s", identifier);
		if ( strcmp(identifier, "f") == 0 )
		{
			faceFound = YES;
			[self readIndices:line];
			continue;
		}
		else
		{
			if ( faceFound )
			{
				break;
			}
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
		if ( strcmp(identifier, "mtllib") == 0 )
		{
			[self parseMtl:line];
			continue;
		}
	}
	fclose(file);
}

- (Vertex*)vertices
{
	return &_vertices[0];
}

- (NSInteger)verticesCount
{
	return _vertices.size();
}

- (GLushort*)indices
{
	return &_indices[0];
}

- (NSInteger)indicesCount
{
	return _indices.size();
}

#pragma mark -
#pragma mark ObjParser ()

- (void)readVertex:(char*)line
{
	Vertex vertex;
	Vertex3D vertex3D;
	sscanf(line, "v %f %f %f", &vertex3D.x, &vertex3D.y, &vertex3D.z);
	vertex.vertex = vertex3D;
	vertex.color = ColorMake(1, 1, 1, 1);
	_vertices.push_back(vertex);
}

- (void)readIndices:(char*)line
{
	char *vertex;
	static int maxIndexCount = 10;
	unsigned short face[maxIndexCount];
	unsigned short text[maxIndexCount];
	unsigned int i = 0;
	int tmp1;
	int tmp2;
	vertex = strtok(line, " "); // first should be "f" sign
	while ( (vertex = strtok(NULL, " ")) && i<maxIndexCount )
	{
		sscanf(vertex, "%d/%d", &tmp1, &tmp2);
		face[i] = (unsigned short)(tmp1-1);
		text[i] = (unsigned short)(tmp2-1);
		++i;
	}
	for (tmp1=1; tmp1<i-1; ++tmp1)
	{
		_indices.push_back(face[0]);
		_indices.push_back(face[tmp1]);
		_indices.push_back(face[tmp1+1]);
	}
	for (tmp1=0; tmp1<i; ++tmp1)
	{
		_vertices.at(face[tmp1]).textCoord = _textCoords.at(text[tmp1]);
	}
}

- (void)readTextureCoords:(char*)line
{
	Vector2D vector;
	sscanf(line, "vt %f %f", &vector.x, &vector.y);
	_textCoords.push_back(vector);
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

@end
