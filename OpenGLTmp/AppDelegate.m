//
//  AppDelegate.m
//  OpenGLTmp
//
//  Created by Adam Zugaj on 10.01.2012.
//  Copyright (c) 2012 ArtProg. All rights reserved.
//

#import "AppDelegate.h"
#import "OpenGLController.h"
#import "APOpenGLEngine.h"

//APOpenGLScene *scene = [[APOpenGLScene alloc] init];

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
	[_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
	OpenGLController *controller = [[[OpenGLController alloc] init] autorelease];
	self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
	
//	[scene startRendering];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
//	[scene stopRendering];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

@end
