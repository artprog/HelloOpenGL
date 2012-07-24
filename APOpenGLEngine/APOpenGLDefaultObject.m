//
//  APOpenGLDefaultObject.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 24.07.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "APOpenGLDefaultObject.h"
#import "APOpenGLProgram.h"

@implementation APOpenGLDefaultObject

- (void)createProgram
{
	NSString *vertex = [[NSBundle mainBundle] pathForResource:@"VertexShader" ofType:@"glsl"];
	NSString *fragment = [[NSBundle mainBundle] pathForResource:@"FragmentShader" ofType:@"glsl"];
	_program = [[APOpenGLProgram alloc] initWithVertexShaderFile:vertex fragmentShaderFile:fragment];
	[_program addAttribute:@"position"];
	[_program addAttribute:@"sourceTextCoord"];
	if ( ![_program link] )
	{
		NSLog(@"Error while linking OpenGL program: \"%@\"!!!", [_program programLog]);
		[_program release], _program = nil;
		return;
	}
	
	_positionSlot = [_program attributeIndex:@"position"];
	_textCoordSlot = [_program attributeIndex:@"sourceTextCoord"];
	
	_projectionUniformSlot = [_program uniformIndex:@"projection"];
	_ambientUniformSlot = [_program uniformIndex:@"ambientColor"];
	_diffuseUniformSlot = [_program uniformIndex:@"diffuseColor"];
	_textureAvailableUniformSlot = [_program uniformIndex:@"textureAvailable"];
	_textureUniformSlot = [_program uniformIndex:@"texture"];
	
	glEnableVertexAttribArray(_positionSlot);
	glEnableVertexAttribArray(_textCoordSlot);
	
	glEnableVertexAttribArray(_projectionUniformSlot);
	glEnableVertexAttribArray(_ambientUniformSlot);
	glEnableVertexAttribArray(_diffuseUniformSlot);
}

@end
