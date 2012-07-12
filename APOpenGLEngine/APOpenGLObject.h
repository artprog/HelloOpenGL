//
//  APOpenGLObject.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 12.07.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

@class APOpenGLParser;

@interface APOpenGLObject : NSObject
{
	@private
	BOOL _built;
}

- (APOpenGLParser*)createParser;

- (BOOL)isBuilt;
- (void)build;
- (void)render;

@end
