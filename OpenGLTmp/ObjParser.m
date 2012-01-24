//
//  ObjParser.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 19.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "ObjParser.h"
#import "Vertex3D.h"

static NSInteger defaultVectorCapacity = 4096;

@interface ObjParser ()
- (void)readVertex:(char*)line;
- (void)readIndices:(char*)line;
@end

@implementation ObjParser

- (id)initWithFile:(NSString*)path
{
	if ( (self = [super init]) )
	{
		_filePath = [path copy];
		_vertices = std::vector<Vertex>(defaultVectorCapacity);
		_indices = std::vector<GLushort>(defaultVectorCapacity);
	}
	return self;
}

- (void)dealloc
{
	[_filePath release];
	
	[super dealloc];
}

- (void)parse
{
	_vertices.clear();
	_indices.clear();
	
	FILE *file = fopen([_filePath cStringUsingEncoding:NSUTF8StringEncoding], "r");
	char line[256];
	char identifier[256];
	while ( fgets(line, sizeof(line), file) )
	{
		sscanf(line, "%s", identifier);
		if ( strcmp(identifier, "v") == 0 )
		{
			[self readVertex:line];
		}
		if ( strcmp(identifier, "f") == 0 )
		{
			[self readIndices:line];
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
	vertex.color = ColorMake(0, 1, 0, 1);
	_vertices.push_back(vertex);
}

- (void)readIndices:(char*)line
{
	char *fragment;
	static int maxIndexCount = 10;
	unsigned short face[maxIndexCount];
	unsigned int i = 0;
	int tmp;
	fragment = strtok(line, " "); // first should be "f" sign
	while ( (fragment = strtok(NULL, " ")) && i<maxIndexCount )
	{
		sscanf(fragment, "%d", &tmp);
		face[i++] = (unsigned short)(tmp-1);
	}
	for (tmp=1; tmp<i-1; ++tmp)
	{
		_indices.push_back(face[0]);
		_indices.push_back(face[tmp]);
		_indices.push_back(face[tmp+1]);
	}
}

@end
