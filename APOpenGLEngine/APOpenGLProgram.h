//
//  APOpenGLProgram.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 03.07.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

/**
 An \class APOpenGLProgram class is responsible for creating GLSL program
 from given paths to vertex shader and fragment shader files. This class also
 manages attributes and uniforms used in the program.
 */
@interface APOpenGLProgram : NSObject
{
	@private
	NSMutableArray *_attributes;
    NSMutableArray *_uniforms;
    GLuint _program;
	GLuint _vertexShader;
	GLuint _fragmentShader;
}

/// Default initializer.
///
/// Paths for vertex shader and fragment shader files should not be nil.
/// If vertex shader or program shader cannot be compiled this method
/// returns nil.
- (id)initWithVertexShaderFile:(NSString*)vertexShaderFile fragmentShaderFile:(NSString*)fragmentShaderFile;

- (void)addAttribute:(NSString*)attributeName;
- (GLuint)attributeIndex:(NSString*)attributeName;
- (GLuint)uniformIndex:(NSString*)uniformName;

/// Links the GLSL program.
/// 
/// Returns YES if success and NO otherwise.
- (BOOL)link;

/// Installs a program object as part of current rendering state
- (void)use;

- (NSString*)vertexShaderLog;
- (NSString*)fragmentShaderLog;
- (NSString*)programLog;

@end
