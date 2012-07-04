//
//  APOpenGLProgram.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 03.07.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "APOpenGLProgram.h"

typedef void (*GLInfoFunction)(GLuint program, GLenum pname, GLint *params);
typedef void (*GLLogFunction) (GLuint program, GLsizei bufsize, GLsizei *length, GLchar *infolog);

@interface APOpenGLProgram ()
- (BOOL)compileShader:(GLuint*)shader type:(GLenum)type file:(NSString*)file;
- (NSString*)logForOpenGLObject:(GLuint)object infoCallback:(GLInfoFunction)infoFunc logFunc:(GLLogFunction)logFunc;
@end

@implementation APOpenGLProgram

- (id)initWithVertexShaderFile:(NSString*)vertexShaderFile fragmentShaderFile:(NSString*)fragmentShaderFile
{
    if ( self = [super init] )
    {
        _attributes = [[NSMutableArray alloc] init];
        _uniforms = [[NSMutableArray alloc] init];
        _program = glCreateProgram();
		
        if ( ![self compileShader:&_vertexShader type:GL_VERTEX_SHADER file:vertexShaderFile] )
		{
            NSLog(@"Failed to compile vertex shader!");
		}
        if ( ![self compileShader:&_fragmentShader type:GL_FRAGMENT_SHADER file:fragmentShaderFile] )
		{
            NSLog(@"Failed to compile fragment shader!");
		}
		
        glAttachShader(_program, _vertexShader);
        glAttachShader(_program, _fragmentShader);
    }
    return self;
}

- (void)dealloc
{
    [_attributes release];
    [_uniforms release];
	
    glDeleteShader(_vertexShader);
	glDeleteShader(_fragmentShader);
	glDeleteProgram(_program);
	
    [super dealloc];
}

- (void)addAttribute:(NSString*)attributeName
{
    if ( ![_attributes containsObject:attributeName] )
    {
        [_attributes addObject:[[attributeName copy] autorelease]];
        glBindAttribLocation(_program, _attributes.count-1, [attributeName UTF8String]);
    }
}

- (GLuint)attributeIndex:(NSString*)attributeName
{
    return [_attributes indexOfObject:attributeName];
}

- (GLuint)uniformIndex:(NSString*)uniformName
{
    return glGetUniformLocation(_program, [uniformName UTF8String]);
}

- (BOOL)link
{
    glLinkProgram(_program);
    glValidateProgram(_program);
	
	GLint status;
    glGetProgramiv(_program, GL_LINK_STATUS, &status);
    if ( status == GL_FALSE )
	{
        return NO;
	}
    glDeleteShader(_vertexShader);
	glDeleteShader(_fragmentShader);
	
    return YES;
}

- (void)use
{
    glUseProgram(_program);
}

- (NSString*)vertexShaderLog
{
    return [self logForOpenGLObject:_vertexShader infoCallback:(GLInfoFunction)&glGetProgramiv logFunc:(GLLogFunction)&glGetProgramInfoLog];
}

- (NSString*)fragmentShaderLog
{
    return [self logForOpenGLObject:_fragmentShader infoCallback:(GLInfoFunction)&glGetProgramiv logFunc:(GLLogFunction)&glGetProgramInfoLog];
}

- (NSString*)programLog
{
    return [self logForOpenGLObject:_program infoCallback:(GLInfoFunction)&glGetProgramiv logFunc:(GLLogFunction)&glGetProgramInfoLog];
}

#pragma mark -
#pragma mark GLProgram ()

- (BOOL)compileShader:(GLuint*)shader type:(GLenum)type file:(NSString*)file
{
    const GLchar *source = [[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:NULL] UTF8String];
    if ( !source )
    {
        NSLog(@"Failed to load shader: %@!", file);
        return NO;
    }
	
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
	
	GLint status;
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    return status == GL_TRUE;
}

- (NSString*)logForOpenGLObject:(GLuint)object infoCallback:(GLInfoFunction)infoFunc logFunc:(GLLogFunction)logFunc
{
    GLint logLength = 0, charsWritten = 0;
	
    infoFunc(object, GL_INFO_LOG_LENGTH, &logLength);    
    if ( logLength < 1 )
	{
        return nil;
	}
	
    char logBytes[logLength];
    logFunc(object, logLength, &charsWritten, logBytes);
    NSString *log = [[[NSString alloc] initWithBytes:logBytes length:logLength encoding:NSUTF8StringEncoding] autorelease];
    return log;
}

@end
