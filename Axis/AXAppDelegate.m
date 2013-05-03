//
//  AXAppDelegate.m
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXAppDelegate.h"

#import "Axis.h"
#import "AXConfiguration.h"

#import "EAGLView.h"
#import "AXDirector.h"
#import "AXSceneController.h"
#import "AXInputViewController.h"

@implementation AXAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // Display Versioning Information in the console.
    if (![AXIS_VERSION_TYPE isEqual: @"Public"])
        NSLog(@"Axis: The Game Engine - %@'s %@", AXIS_VERSION_NAME, AXIS_VERSION_NAME_ADDITION);
    else
        NSLog(@"Axis: The Game Engine - %@ %@", AXIS_VERSION_NAME, AXIS_VERSION_NAME_ADDITION);
    NSLog(@"%@ Engine %@ %@ build %@", AXIS_VERSION_FORM, AXIS_VERSION_TYPE, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]);
    
    NSLog(@"Juco: %@", AXIS_JUST_COMPLETED);
    NSLog(@"Todo High Priority: %@", AXIS_TODO_HIGH);
    NSLog(@"Todo Low Priority: %@", AXIS_TODO_LOW);
    
    // Initialise the SceneController
    AXSceneController *sceneController = [AXSceneController sharedSceneController];
    
    // Initialise the Input Controller
    AXInputViewController *anInputController = [[AXInputViewController alloc] initWithNibName:nil bundle:nil];
    // Give the SceneController the inputController
    sceneController.inputController = anInputController;
    [anInputController release];
    
    // Initialise main EAGLView with window bounds
    EAGLView *glView = [[EAGLView alloc] initWithFrame:_window.bounds];
    sceneController.inputController.view = glView;
    sceneController.openGLView = glView;
    [glView release];
    
    // set our view as the first window view
    self.window.rootViewController = sceneController.inputController;
    [self.window makeKeyAndVisible];
    
    // tell the director to continue setup
    [[AXDirector sharedDirector] setupEngine];
}

/* Original
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[AXViewController alloc] initWithNibName:@"AXViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[AXViewController alloc] initWithNibName:@"AXViewController_iPad" bundle:nil] autorelease];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}*/

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
