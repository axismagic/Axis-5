//
//  AXNewScene.m
//  Axis
//
//  Created by Jethro Wilson on 14/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXNewScene.h"
#import "AXTouch.h"

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
    [hero addChild:enemy];
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
    // get touches
    NSSet *touches = [[AXDirector sharedDirector].inputController touchEvents];
    
    if ([touches count] == 0)
        return;
    
    for (AXTouch *touch in [touches allObjects]) {
        if (touch.phase == AXTouchPhaseBegan) {
            // **** Needs to hide currentPoint - Access through: CGPoint touchPoint = [touch locationInView:[touch view]];
            
            AXPoint touchPointLoc = AXPointMake(touch.currentPoint.x, touch.currentPoint.y, hero.location.z);
            
            // move to point action
            AXAction *moveToPoint = [[AXAction alloc] initWithTransformationType:AXACTransformationMovement transformationMode:AXACTransformTo transformation:touchPointLoc duration:1];
            
            [hero performAction:moveToPoint];
        }
    }
}

@end