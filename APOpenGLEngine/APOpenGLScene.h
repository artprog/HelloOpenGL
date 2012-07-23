//
//  APOpenGLScene.h
//  OpenGLTmp
//
//  Created by Adam Zugaj on 03.07.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

@class APOpenGLRenderer;
@class APOpenGLObject;

@interface APOpenGLScene : UIView
{
	@private
	APOpenGLRenderer *_renderer;
}

//@property (nonatomic, readonly) APOpenGLRenderer *renderer;

- (void)renderSingleFrame;
- (void)startRendering;
- (void)stopRendering;

- (void)addObject:(APOpenGLObject*)object;
- (void)addObjects:(NSArray*)objects;

@end
