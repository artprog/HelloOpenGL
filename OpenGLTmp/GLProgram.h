//
//  GLProgram.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 12.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import <OpenGLES/EAGL.h>

@interface GLProgram : NSObject
{
	@private
	NSMutableArray *_attributes;
    NSMutableArray *_uniforms;
    GLuint _program;
	GLuint _vertexShader;
	GLuint _fragmentShader;
}

- (id)initWithVertexShaderFile:(NSString*)vertexShaderFile fragmentShaderFile:(NSString*)fragmentShaderFile;

- (void)addAttribute:(NSString*)attributeName;
- (GLuint)attributeIndex:(NSString*)attributeName;
- (GLuint)uniformIndex:(NSString*)uniformName;

- (BOOL)link;
- (void)use;

- (NSString*)vertexShaderLog;
- (NSString*)fragmentShaderLog;
- (NSString*)programLog;

@end
