//
//  APOpenGLParser.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 12.07.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#include <vector>
#import "GLModel.h"

@interface APOpenGLParser : NSObject
{
	@protected
	NSString *_path;
	std::vector<TriangleVertex> _vertices;
	std::vector<GLushort> _indices;
	std::vector<Vector2D> _textCoords;
	std::vector<Vector3D> _normalVectors;
}

- (id)initWithPath:(NSString*)path;

- (BOOL)parse:(NSError**)error;

- (TriangleVertex*)triangleVertices;
- (NSUInteger)triangleVerticesCount;

- (GLushort*)indices;
- (NSUInteger)indicesCount;

@end
