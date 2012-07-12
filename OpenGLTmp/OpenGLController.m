//
//  OpenGLController.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 10.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "OpenGLController.h"
#import "APOpenGLEngine.h"

@implementation OpenGLController

- (void)dealloc
{
	[_scene.renderer stopRendering];
	[_scene release];
	
	[super dealloc];
}

- (void)loadView
{
	[super loadView];
	
	CGRect frame = self.view.bounds;
	
	_scene = [[APOpenGLScene alloc] initWithFrame:frame];
	_scene.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:_scene];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[_scene.renderer startRendering];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
	[_scene.renderer stopRendering];
	[_scene release], _scene = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

@end
