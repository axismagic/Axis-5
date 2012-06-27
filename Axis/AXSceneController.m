//
//  AXSceneController.m
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXSceneController.h"
#import "AXInputViewController.h"
#import "AXCollisionController.h"
#import "EAGLView.h"
#import "AXSceneObject.h"

#import "AXSpaceShip.h"
#import "AXRock.h"

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
    
    // seed randomiser
    RANDOM_SEED();
    
    // create the ship
    AXSpaceShip *ship = [[AXSpaceShip alloc] init];
    ship.scale = AXPointMake(2.5, 2.5, 1.0);
    [self addObjectToScene:ship];
    [ship release];
    
    // load rocks
    [self generateRocks];
    
    // load collisionController
    collisionController = [[AXCollisionController alloc] init];
    collisionController.sceneObjects = sceneObjects;
    if (DEBUG_DRAW_COLLIDERS)
        [self addObjectToScene:collisionController];
    
    // load interface
    [inputController loadInterface];
}

- (void)startScene {
    self.animationInterval = 1.0/60.0;
    [self startAnimation];
}

#pragma mark Game Specific

- (void)generateRocks {
    NSInteger rockCount = 10;
    NSInteger index;
    for (index = 0; index < rockCount; index++) {
        [self addObjectToScene:[AXRock randomRock]];
    }
}

#pragma mark Game Loop

- (void)gameLoop {
    // autorelease pool
    NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
    
    // add queued scene objects
    if ([objectsToAdd count] > 0) {
        [sceneObjects addObjectsFromArray:objectsToAdd];
        [objectsToAdd removeAllObjects];
    }
    
    // apply inputs to objects in the scene
    [self updateModel];
    // deal with collisions
    [collisionController handleCollisions];
    // send objects to the renderer
    [self renderScene];
    
    // remove old objects
    if ([objectsToRemove count] > 0) {
        [sceneObjects removeObjectsInArray:objectsToRemove];
        [objectsToRemove removeAllObjects];
    }
    
    [apool release];
}

- (void)updateModel {
    // call update on all interface objects
    [inputController updateInterface];
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
    // draw interface on top of everything
    [inputController renderInterface];
    // finilise frame
    [openGLView finishDraw];
}

- (void)addObjectToScene:(AXSceneObject *)sceneObject {
    if (objectsToAdd == nil)
        objectsToAdd = [[NSMutableArray alloc] init];
    // activate and wake object
    sceneObject.active = YES;
    [sceneObject awake];
    [objectsToAdd addObject:sceneObject];
}

- (void)removeObjectFromScene:(AXSceneObject *)sceneObject {
    if (objectsToRemove == nil)
        objectsToRemove = [[NSMutableArray alloc] init];
    [objectsToRemove addObject:sceneObject];
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
