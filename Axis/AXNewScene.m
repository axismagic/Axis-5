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
    hero = [[AXMobileSprite alloc] initWithSpriteImage:@"HeroFront"];
    hero.location = AXPointMake(300, 100, 0);
    hero.collisionDetection = YES;
    [self addChild:hero];
    [hero activate];
    [hero release];
    
    /*AXAction *upScale = [[AXAction alloc] initWithTransformationType:AXACTransformationScale transformationMode:AXACTransformBy transformation:AXPointMake(1.0, 1.0, 0) duration:0.75];
    
    [hero performAction:upScale];*/
}

#pragma mark - Visual Interface Updates

- (void)updateWithTouchLocation:(AXPoint)location {
    // move to point action
    /*AXAction *moveToPoint = [[AXAction alloc] initWithTransformationType:AXACTransformationMovement transformationMode:AXACTransformTo transformation:location duration:1];
    
    [hero performAction:moveToPoint];*/
    
    hero.speed = location;
}

- (void)actionoccured:(BOOL)action {
    if (!action)
        return;
    /*AXAction *upScale = [[AXAction alloc] initWithTransformationType:AXACTransformationScale transformationMode:AXACTransformBy transformation:AXPointMake(1.0, 1.0, 0) duration:0.75];
    
    [hero performAction:upScale];*/
    
    hero.scale = AXPointMake(2, 2, 1);
}

@end