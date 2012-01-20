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
- (Vertex3D)readVertex:(NSArray*)components;
- (NSArray*)readIndices:(NSArray*)components;
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
	NSString *fileContents = [[NSString alloc] initWithContentsOfFile:_filePath encoding:NSUTF8StringEncoding error:NULL];
	NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	NSArray *components;
	[fileContents release];
	for (NSString *line in lines)
	{
		components = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		if ( components.count )
		{
			if ( strcmp([(NSString*)[components objectAtIndex:0] cStringUsingEncoding:NSUTF8StringEncoding], "v") == 0 )
			{
				Vertex3D vertex = [self readVertex:[components subarrayWithRange:NSMakeRange(1, components.count-1)]];
				[_vertices addObject:[NSValue valueWithBytes:&vertex objCType:@encode(Vertex3D)]];
			}
			if ( strcmp([(NSString*)[components objectAtIndex:0] cStringUsingEncoding:NSUTF8StringEncoding], "f") == 0 )
			{
				[_indices addObjectsFromArray:[self readIndices:components]];
			}
		}
	}
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

- (Vertex3D)readVertex:(NSArray*)components
{
	Vertex3D vertex = {0, 0, 0};
	GLfloat *vertexPointer = (GLfloat*)(&vertex);
	if ( components.count == 3 )
	{
		for (NSInteger i=0; i<3; ++i)
		{
			vertexPointer[i] = [[components objectAtIndex:i] floatValue];
		}
	}
	return vertex;
}

- (NSArray*)readIndices:(NSArray*)components
{
	NSMutableArray *indices = [NSMutableArray array];
	NSArray *indicesTmp;
	for (NSString *component in components)
	{
		indicesTmp = [component componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
		if ( indicesTmp.count == 3 )
		{
			for (NSString *index in indicesTmp)
			{
				[indices addObject:[NSNumber numberWithUnsignedInteger:[index integerValue]]];
			}
		}
	}
	return indices;
}

@end
