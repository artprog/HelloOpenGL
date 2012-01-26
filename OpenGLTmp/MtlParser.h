//
//  MtlParser.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 26.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "Color.h"

typedef struct
{
	GLfloat Ns;
	Color Ka;
	Color Kd;
	Color Ks;
	GLfloat Ni;
	GLfloat d;
	GLuint illum;
	char map_Kd[256];
	char name[256];
} Material;

Material MaterialMakeZero();

@interface MtlParser : NSObject
{
	@private
	NSString *_filePath;
	NSMutableDictionary *_materials;
}

@property (nonatomic, readonly) NSDictionary *materials;

- (id)initWithFile:(NSString*)path;

- (void)parse;

@end
