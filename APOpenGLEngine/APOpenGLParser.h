//
//  APOpenGLParser.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 12.07.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

@interface APOpenGLParser : NSObject
{
	@private
	NSString *_path;
}

- (id)initWithPath:(NSString*)path;

- (BOOL)parse:(NSError**)error;

@end
