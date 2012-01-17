//
//  OpenGLView.h
//  OpenGLTmp
//
//  Created by SMT Software on 10.01.2012.
//  Copyright (c) 2012 SMTSoftware. All rights reserved.
//

#import "ESRenderer.h"

@interface OpenGLView : UIView
{
	@private
	BOOL _animating;
	CADisplayLink *_displayLink;
	NSInteger _animationFrameInterval;
	ESRenderer *_renderer;
}

@property (readonly, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

- (void)startAnimation;
- (void)stopAnimation;

@end
