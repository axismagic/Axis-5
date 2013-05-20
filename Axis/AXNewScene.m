//
//  AXNewScene.m
//  Axis
//
//  Created by Jethro Wilson on 14/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXNewScene.h"

#import "AXHeroOne.h"
#import "AXEnemy.h"

@implementation AXNewScene

- (void)dealloc {
    [[AXDirector sharedDirector].inputController unregisterObjectForTouches:self];
    [super dealloc];
}

- (void)loadScene {
    [super loadScene];
    
    // load hero
    hero = [[AXHeroOne alloc] initWithSpriteImage:@"HeroFront"];
    hero.location = AXPointMake(250, 100, 0);
    hero.collisionDetection = YES;
    [self addChild:hero];
    [hero activate];
    [hero release];
    
    // load enemy
    enemy = [[AXEnemy alloc] initWithSpriteImage:@"HeroSide"];
    enemy.location = AXPointMake(100, 50, 0);
    enemy.collisionDetection = YES;
    [hero addChild:enemy];
    [enemy activate];
    [enemy release];
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
    AXAction *upScale = [[AXAction alloc] initWithTransformationType:AXACTransformationScale transformationMode:AXACTransformTo transformation:AXPointMake(2.0, 2.0, 0) duration:0.75];
    
    [hero performAction:upScale];
    hero.rotation = AXPointMake(hero.rotation.x, hero.rotation.y, hero.rotation.z-5);
    
    //hero.scale = AXPointMake(2, 2, 1);
}

@end