//
//  AXNewScene.m
//  Axis
//
//  Created by Jethro Wilson on 14/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXNewScene.h"

@implementation AXNewScene

- (void)loadScene {
    [super loadScene];
    
    hero = [[AXMobileSprite alloc] initWithSpriteImage:@"HeroFront"];
    hero.location = AXPointMake(100.0, 100.0, 0.0);
    hero.collisionDetection = YES;
    [self addChild:hero];
    [hero activate];
    [hero release];
    
    enemy = [[AXMobileSprite alloc] initWithSpriteImage:@"HeroFront"];
    enemy.location = AXPointMake(250.0, 100.0, 0.0);
    enemy.collisionDetection = YES;
    enemy.actionQueuemode = AXACQueueSetNoQueue_InterruptCurrent;
    [self addChild:enemy];
    [enemy activate];
    [enemy release];
}

- (void)updateScene {
    // add new objects
    if ([childrenToAdd count] > 0) {
        //[sceneObjects addObjectsFromArray:objectsToAdd];
        [children addObjectsFromArray:childrenToAdd];
        [childrenToAdd removeAllObjects];
    }
    
    // update interface
    // ***** only if is active?
    // ***** when should update interface? begin/mid/end
    // if (active)
    [_interfaceController updateInterface];
    
    // update touches
    [self updateTouches];
    
    // update all objects
    // *R?* [sceneObjects makeObjectsPerformSelector:@selector(update)];
    [children makeObjectsPerformSelector:@selector(update)];
    
    // handle collisions
    [_collisionController handleCollisions];
    
    // remove old objects
    if ([childrenToRemove count] > 0) {
        [children removeObjectsInArray:childrenToRemove];
        [childrenToRemove removeAllObjects];
    }
}

#pragma mark - Touches

- (void)updateTouches {
    NSSet *touches = [[AXSceneController sharedSceneController].inputController touchEvents];
    
    if ([touches count] == 0)
        return;
    
    for (UITouch *touch in [touches allObjects]) {
        if (touch.phase != UITouchPhaseEnded) {
            CGPoint touchPoint = [touch locationInView:[touch view]];
            // correct y coordinate
            // ***** correction works for iPhone 4 only. This corrections needs to happen within input controller (or it needs a method which returns correct y coord)
            
            // get touch location
            CGSize correctorFloat = [[AXSceneController sharedSceneController] viewSize];
            
            AXPoint touchPointLoc = AXPointMake(touchPoint.x, correctorFloat.height-touchPoint.y, hero.location.z);
            // create new action
            AXAction *newAction = [[AXAction alloc] initWithTransformationType:AXACTransformationMovement transformationMode:AXACTransformTo transformation:touchPointLoc duration:1];
            AXAction *newActionS = [[AXAction alloc] initWithTransformationType:AXACTransformationScale transformationMode:AXACTransformBy transformation:AXPointMake(1, 1, 0) duration:1];
            
            [hero performAction:newAction];
            [hero performAction:newActionS];
            [enemy performAction:newAction];
            
            
        }
        if (touch.phase == UITouchPhaseMoved) {
            NSLog(@"Moved");
        }
    }
}

@end