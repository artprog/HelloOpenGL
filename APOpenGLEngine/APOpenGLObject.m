//
//  APOpenGLObject.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 12.07.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "APOpenGLObject.h"
#import "APOpenGLParser.h"

@implementation APOpenGLObject

- (APOpenGLParser*)createParser
{
	return nil;
}

- (BOOL)isBuilt
{
	return _built;
}

- (void)build
{
	if ( !_built )
	{
//	APOpenGLParser *parser = [self createParser];
		_built = YES;
	}
}

- (void)render
{
}

@end
