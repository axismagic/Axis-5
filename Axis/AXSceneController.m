//
//  AXSceneController.m
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXSceneController.h"
#import "AXInputViewController.h"
#import "EAGLView.h"
#import "AXSceneObject.h"

@implementation AXSceneController

@synthesize inputController, openGLView;
@synthesize  animationTimer, animationInterval;

+ (AXSceneController*)sharedSceneController {
    static AXSceneController *sharedSceneController;
    @synchronized(self) {
        if (!sharedSceneController)
            sharedSceneController = [[AXSceneController alloc] init];
    }
    
    return sharedSceneController;
}

#pragma  mark Scene Preload

- (void)loadScene {
    sceneObjects = [[NSMutableArray alloc] init];
    
    // add a single scene object for testing
    AXSceneObject *object = [[AXSceneObject alloc] init];
    [object awake];
    [sceneObjects addObject:object];
    [object release];
}

- (void)startScene {
    self.animationInterval = 1.0/60.0;
    [self startAnimation];
}

#pragma mark Game Loop

- (void)gameLoop {
    // apply inputs to objects in the scene
    [self updateModel];
    // send objects to the renderer
    [self renderScene];
}

- (void)updateModel {
    // call update on all objects
    [sceneObjects makeObjectsPerformSelector:@selector(update)];
    // clear events
    [inputController clearEvents];
}

- (void)renderScene {
    // turn openGL 'on'
    [openGLView beginDraw];
    // call render on all objects in the scene
    [sceneObjects makeObjectsPerformSelector:@selector(render)];
    // finilise frame
    [openGLView finishDraw];
}

#pragma mark Animation Timer

- (void)startAnimation {
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}

- (void)stopAnimation {
    self.animationTimer = nil;
}

- (void)setAnimationTimer:(NSTimer *)newTimer {
    [animationTimer invalidate];
    animationTimer = newTimer;
}

- (void)setAnimationInterval:(NSTimeInterval)interval {
    animationInterval = interval;
    if (animationTimer) {
        [self stopAnimation];
        [self startAnimation];
    }
}

#pragma mark Dealloc

- (void)dealloc {
    [self stopAnimation];
    [super dealloc];
}

@end
