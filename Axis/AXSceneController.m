//
//  AXSceneController.m
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXSceneController.h"
#import "AXConfiguration.h"
#import "AXInputViewController.h"
#import "AXCollisionController.h"
#import "EAGLView.h"
#import "AXSpaceShip.h"
#import "AXRock.h"
#import "AXParticleEmitter.h"

@implementation AXSceneController

@synthesize inputController, openGLView;
@synthesize animationTimer, animationInterval;
@synthesize levelStartDate, deltaTime;
@synthesize viewSize;

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
    //ship.scale = AXPointMake(2.5, 2.5, 1.0);
    [self addObjectToScene:ship];
    [ship release];
    
    // load rocks
    [self generateRocks];
    
    // load collisionController
    collisionController = [[AXCollisionController alloc] init];
    collisionController.sceneObjects = sceneObjects;
    if (AX_DEBUG_DRAW_COLLIDERS)
        [self addObjectToScene:collisionController];
    
    // load interface
    [inputController loadInterface];
}

- (void)startScene {
    self.animationInterval = 1.0/60.0;
    [self startAnimation];
    
    // reset clock
    self.levelStartDate = [NSDate date];
    lastFrameStartTime = 0;
}

#pragma mark Game Specific

- (void)generateRocks {
    NSInteger rockCount = 20;
    NSInteger index;
    for (index = 0; index < rockCount; index++) {
        [self addObjectToScene:[AXRock randomRock]];
    }
}

#pragma mark Game Loop

- (void)gameLoop {
    // autorelease pool
    NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
    
    thisFrameStartTime = [levelStartDate timeIntervalSinceNow];
    deltaTime = lastFrameStartTime - thisFrameStartTime;
    lastFrameStartTime = thisFrameStartTime;
    
    // current frame rate
    if (AX_CONSOLE_DISPLAY_ALL_FRAME_RATES) {
        // display with warnings highlighted
        if (AX_CONSOLE_LOW_FRAME_RATE_WARNING) {
            // warning format or not for this frame
            if (1.0/deltaTime < AX_CONSOLE_LOW_FRAME_RATE_WARNING_MARK)                NSLog(@"Current Frame Rate LOW: %f", 1.0/deltaTime);
            else
                NSLog(@"Current Frame Rate: %f", 1.0/deltaTime);
        } else
            // display all in normal format, no warnings
            NSLog(@"Current Frame Rate: %f", 1.0/deltaTime); 
    } else if (AX_CONSOLE_LOW_FRAME_RATE_WARNING) {
        // only warnings
        if (1.0/deltaTime < AX_CONSOLE_LOW_FRAME_RATE_WARNING_MARK)
            NSLog(@"Current Frame Rate LOW: %f", 1.0/deltaTime);
    }
    
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
    if (AX_USE_DISPLAY_LINK) {
        NSLog(@"Using Display Link");
        if (displayLink)
            return;
        
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(gameLoop)];
        [displayLink retain];
        displayLink.frameInterval = 1;
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    } else {
        NSLog(@"Using Animation Timer");
    }
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}

- (void)stopAnimation {
    if (AX_USE_DISPLAY_LINK) {
        [displayLink invalidate];
        [displayLink release];
        displayLink = nil;
    } else {
        self.animationTimer = nil;
    }
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
    
    [sceneObjects release];
    [objectsToAdd release];
    [objectsToRemove release];
    [inputController release];
    [openGLView release];
    [collisionController release];
    [super dealloc];
}

@end
