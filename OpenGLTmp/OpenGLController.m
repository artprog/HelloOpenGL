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
	[_scene stopRendering];
	[_scene release];
	[_object release];
	
	[super dealloc];
}

- (void)loadView
{
	[super loadView];
	
	CGRect frame = self.view.bounds;
	
	_scene = [[APOpenGLScene alloc] initWithFrame:frame];
	_scene.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:_scene];
	
	_object = [[APOpenGLObject alloc] init];
	[_scene addObject:_object];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[_scene startRendering];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
	[_scene stopRendering];
	[_scene release], _scene = nil;
	[_object release], _object = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

@end
