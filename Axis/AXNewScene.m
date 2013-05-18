//
//  AXNewScene.m
//  Axis
//
//  Created by Jethro Wilson on 14/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXNewScene.h"

#import "AXHeroOne.h"

@implementation AXNewScene

- (void)dealloc {
    [[AXDirector sharedDirector].inputController unregisterObjectForTouches:self];
    [super dealloc];
}

- (void)loadScene {
    [super loadScene];
    
    // load heros
    AXHeroOne *heroOne = [[AXHeroOne alloc] initWithSpriteImage:@"HeroFront"];
    heroOne.location = AXPointMake(300, 100, 0);
    heroOne.collisionDetection = YES;
    [self addChild:heroOne];
    [heroOne activate];
    [heroOne release];
}

#pragma mark - Visual Interface Updates

- (void)updateWithTouchLocation:(AXPoint)location {
    // move to point action
    AXAction *moveToPoint = [[AXAction alloc] initWithTransformationType:AXACTransformationMovement transformationMode:AXACTransformTo transformation:location duration:1];
    
    [hero performAction:moveToPoint];
}

@end