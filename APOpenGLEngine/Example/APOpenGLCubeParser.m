//
//  APOpenGLCubeParser.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 24.07.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "APOpenGLCubeParser.h"
#import "APMath.h"

@implementation APOpenGLCubeParser

- (BOOL)parse:(NSError**)error
{
	const APVertex Vertices[] = {
		{{1, -1, 0}, {0, 0}, {0, 0, 0}},
		{{1, 1, 0}, {0, 0}, {0, 0, 0}},
		{{-1, 1, 0}, {0, 0}, {0, 0, 0}},
		{{-1, -1, 0}, {0, 0}, {0, 0, 0}}
	};
	
	const GLubyte Indices[] = {
		0, 1, 2,
		2, 3, 0
	};
	return YES;
}

@end
