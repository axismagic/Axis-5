//
//  AXNewScene.m
//  Axis
//
//  Created by Jethro Wilson on 14/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXNewScene.h"
#import "AXHero.h"
#import "AXMobileSprite.h"

@implementation AXNewScene

- (void)loadScene {
    [super loadScene];
    
    AXMobileSprite *heroSide = [[AXMobileSprite alloc] initWithSpriteImage:@"HeroFront"];
    heroSide.location = AXPointMake(0.0, 0.0, 0.0);
    heroSide.speed = AXPointMake(0.0, 0.2, 0.0);
    heroSide.collisionDetection = YES;
    [self addChild:heroSide];
    [heroSide activate];
    [heroSide release];
}

@end
