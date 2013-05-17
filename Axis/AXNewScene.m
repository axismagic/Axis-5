//
//  AXNewScene.m
//  Axis
//
//  Created by Jethro Wilson on 14/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXNewScene.h"

@implementation AXNewScene

- (void)dealloc {
    [[AXDirector sharedDirector].inputController unregisterObjectForTouches:self];
    [super dealloc];
}

- (void)loadScene {
    [super loadScene];
    
    hero = [[AXMobileSprite alloc] initWithSpriteImage:@"HeroFront"];
    hero.location = AXPointMake(100.0, 100.0, 0.0);
    hero.collisionDetection = YES;
    hero.actionQueuemode = AXACQueueSetNoQueue_InterruptCurrent;
    [self addChild:hero];
    [hero activate];
    [hero release];
}

#pragma mark - Visual Interface Updates

- (void)updateWithTouchLocation:(AXPoint)location {
    // move to point action
    AXAction *moveToPoint = [[AXAction alloc] initWithTransformationType:AXACTransformationMovement transformationMode:AXACTransformTo transformation:location duration:1];
    
    [hero performAction:moveToPoint];
}

@end