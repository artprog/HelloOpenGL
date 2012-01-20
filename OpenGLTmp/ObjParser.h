//
//  ObjParser.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 19.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

@interface ObjParser : NSObject
{
	@private
	NSString *_filePath;
	NSMutableArray *_vertices;
	NSMutableArray *_indices;
}

- (id)initWithFile:(NSString*)path;

- (void)parse;

- (NSArray*)vertices;
- (NSArray*)indices;

@end
