//
//  APOpenGLParser.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 12.07.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#include <vector>
#import "APMath.h"

typedef struct
{
	APPoint vertex;
	APTextCoord textCoord;
	APNormal normal;
} APOpenGLParserPoint;

/**
 \class APOpenGLParser is an abstract class used to read 3D model file
 into memory.
 */
@interface APOpenGLParser : NSObject
{
	@protected
	NSString *_path;
	std::vector<APPoint> _vertices;
	std::vector<APTextCoord> _textCoords;
	std::vector<APNormal> _normals;
	std::vector<APOpenGLParserPoint> _faces;
	std::vector<GLushort> _indices;
}

- (id)initWithPath:(NSString*)path;

- (BOOL)parse:(NSError**)error;

/// Returns an array of vertices.
/// 
/// Each vertex can consist of several structures (such as position,
/// texture coordinates, normal vector). Concrete structures which each
/// vertex consists of, depends on the 3D model file.
- (void*)vertices;
- (NSUInteger)verticesCount;

- (GLushort*)indices;
- (NSUInteger)indicesCount;

@end
