//
//  ObjParser.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 19.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#include <vector>

#import "Vertex3D.h"
#import "Color.h"
#import "Vector2D.h"

typedef struct
{
	Vertex3D vertex;
	Vector2D textCoord;
	Color color;
} Vertex;

@interface ObjParser : NSObject
{
	@private
	NSString *_filePath;
	std::vector<Vertex> _vertices;
	std::vector<Vector2D> _textCoords;
	std::vector<GLushort> _indices;
}

- (id)initWithFile:(NSString*)path;

- (void)parse;

- (Vertex*)vertices;
- (NSInteger)verticesCount;

- (GLushort*)indices;
- (NSInteger)indicesCount;

@end
