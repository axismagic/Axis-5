//
//  AXNewScene.m
//  Axis
//
//  Created by Jethro Wilson on 14/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXNewScene.h"
#import "AXRock.h"
#import "AXSpaceShip.h"

@implementation AXNewScene

- (void)loadScene {
    /*if (sceneObjects == nil)
        sceneObjects = [[NSMutableArray alloc] init];*/
    
    [super loadScene];
    
    // create rock
    AXRock *rock = [AXRock randomRock];
    rock.location = AXPointMake(0.0, 0.0, 0.0);
    rock.speed = AXPointMake(0.0, -0.2, 0.0);
    [self addObjectToScene:rock];
    
    AXSpaceShip *ship = [[AXSpaceShip alloc] init];
    ship.location = AXPointMake(-100.0, 0.0, 0.0);
    [rock addChild:ship];
}

@end
