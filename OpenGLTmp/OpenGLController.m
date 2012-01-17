//
//  OpenGLController.m
//  OpenGLTmp
//
//  Created by SMT Software on 10.01.2012.
//  Copyright (c) 2012 SMTSoftware. All rights reserved.
//

#import "OpenGLController.h"
#import "OpenGLView.h"

@implementation OpenGLController

- (void)loadView
{
	[super loadView];
	
	CGRect frame = self.view.bounds;
	
	CGSize viewSize = CGSizeMake(frame.size.width/2.f, frame.size.height/2.f);
	CGPoint viewOrigin = CGPointMake((frame.size.width-viewSize.width)/2.f,
									 (frame.size.height-viewSize.height)/2.f);
	CGRect viewFrame;
	viewFrame.origin = viewOrigin;
	viewFrame.size = viewSize;
	OpenGLView *view = [[OpenGLView alloc] initWithFrame:viewFrame];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:view];
	[view release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

@end
