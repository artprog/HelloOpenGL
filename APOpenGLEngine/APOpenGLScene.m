//
//  APOpenGLScene.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 03.07.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "APOpenGLScene.h"
#import "APOpenGLRenderer.h"
#import <QuartzCore/QuartzCore.h>

@implementation APOpenGLScene

@synthesize renderer = _renderer;

- (id)initWithFrame:(CGRect)frame
{
    if ( (self = [super initWithFrame:frame]) )
    {
		CAEAGLLayer *layer = (CAEAGLLayer*)self.layer;
		
        // Construct a dictionary with our configurations.
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
							  kEAGLColorFormatRGB565, kEAGLDrawablePropertyColorFormat,
							  nil];
		
        // Set the properties to CAEAGLLayer.
        [layer setDrawableProperties:dict];
		layer.opaque = YES;
		
		_renderer = [[APOpenGLRenderer alloc] init];
    }
    return self;
}

- (void)dealloc
{
	[_renderer release];
	
	[super dealloc];
}

- (void)layoutSubviews
{
	[_renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
}

+ (Class)layerClass
{
	return [CAEAGLLayer class];
}

@end
