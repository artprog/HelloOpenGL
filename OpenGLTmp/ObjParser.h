//
//  ObjParser.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 19.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "GLModel.h"
#import "MtlParser.h"

@interface ObjParser : NSObject
{
	@private
	NSString *_filePath;
	std::vector<TriangleVertex> _vertices;
	std::vector<Vector2D> _textCoords;
	std::vector<Vector3D> _normalVectors;
	std::vector<GLushort> _indices;
	std::vector<Mesh> _meshes;
	MtlParser *_mtlParser;
}

- (id)initWithFile:(NSString*)path;

- (void)parse;

- (TriangleVertex*)triangleVertices;
- (NSUInteger)triangleVerticesCount;

- (GLushort*)indices;
- (NSUInteger)indicesCount;

- (Mesh*)meshes;
- (NSUInteger)meshesCount;

@end
