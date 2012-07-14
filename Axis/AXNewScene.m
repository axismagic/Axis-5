//
//  AXNewScene.m
//  Axis
//
//  Created by Jethro Wilson on 14/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXNewScene.h"
#import "AXRock.h"

@implementation AXNewScene

- (void)loadScene {
    if (sceneObjects == nil)
        sceneObjects = [[NSMutableArray alloc] init];
    
    // create rock
    AXRock *rock = [AXRock randomRock];
    rock.translation = AXPointMake(0.0, 0.0, 0.0);
    rock.speed = AXPointMake(0.0, 0.0, 0.0);
    [self addObjectToScene:rock];
}

@end
