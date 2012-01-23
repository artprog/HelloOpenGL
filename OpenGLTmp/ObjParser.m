//
//  ObjParser.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 19.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "ObjParser.h"
#import "Vertex3D.h"

@interface ObjParser ()
- (Vertex3D)readVertex:(char*)line;
- (NSArray*)readIndices:(char*)line;
@end

@implementation ObjParser

- (id)initWithFile:(NSString*)path
{
	if ( (self = [super init]) )
	{
		_filePath = [path copy];
		_vertices = [[NSMutableArray alloc] init];
		_indices = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[_filePath release];
	[_vertices release];
	[_indices release];
	
	[super dealloc];
}

- (void)parse
{
	FILE *file = fopen([_filePath cStringUsingEncoding:NSUTF8StringEncoding], "r");
	char line[128];
	char identifier[4];
	while ( fgets(line, sizeof(line), file) )
	{
		sscanf(line, "%s", identifier);
		if ( strcmp(identifier, "v") == 0 )
		{
			Vertex3D vertex = [self readVertex:line];
			[_vertices addObject:[NSValue valueWithBytes:&vertex objCType:@encode(Vertex3D)]];
		}
		if ( strcmp(identifier, "f") == 0 )
		{
			[_indices addObjectsFromArray:[self readIndices:line]];
		}
	}
	fclose(file);
}

- (NSArray*)vertices
{
	return _vertices;
}

- (NSArray*)indices
{
	return _indices;
}

#pragma mark -
#pragma mark ObjParser ()

- (Vertex3D)readVertex:(char*)line
{
	Vertex3D vertex;
	sscanf(line, "v %f %f %f", &vertex.x, &vertex.y, &vertex.z);
	return vertex;
}

- (NSArray*)readIndices:(char*)line
{
	NSMutableArray *indices = [NSMutableArray array];
	char *fragment;
	const int maxIndexCount = 10;
	unsigned short face[maxIndexCount];
	unsigned int i = 0;
	int tmp;
	fragment = strtok(line, " "); // first should be "f" sign
	while ( (fragment = strtok(NULL, " ")) && i<maxIndexCount )
	{
		sscanf(fragment, "%d", &tmp);
		face[i++] = (unsigned short)tmp;
	}
	for (int j=1; j<i-1; ++j)
	{
		[indices addObject:[NSNumber numberWithUnsignedShort:face[0]]];
		[indices addObject:[NSNumber numberWithUnsignedShort:face[j]]];
		[indices addObject:[NSNumber numberWithUnsignedShort:face[j+1]]];
	}
	return indices;
}

@end
