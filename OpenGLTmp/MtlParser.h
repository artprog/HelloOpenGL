//
//  MtlParser.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 26.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "GLModel.h"

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
