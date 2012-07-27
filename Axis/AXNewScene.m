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
    if (sceneObjects == nil)
        sceneObjects = [[NSMutableArray alloc] init];
    
    // create rock
    AXRock *rock = [AXRock randomRock];
    rock.translation = AXPointMake(0.0, 0.0, 0.0);
    rock.speed = AXPointMake(0.0, 0.0, 0.0);
    [self addObjectToScene:rock];
    
    AXSpaceShip *ship = [[AXSpaceShip alloc] init];
    ship.translation = AXPointMake(-100.0, 0.0, 0.0);
    [self addObjectToScene:ship];
}

@end
