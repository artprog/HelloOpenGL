//
//  APOpenGLParser.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 12.07.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "APOpenGLParser.h"

@implementation APOpenGLParser

- (id)initWithPath:(NSString *)path
{
	if ( (self = [super init]) )
	{
		_path = [path copy];
	}
	return self;
}

- (void)dealloc
{
	[_path release];
	
	[super dealloc];
}

- (BOOL)parse:(NSError**)error
{
	return NO;
}

@end
