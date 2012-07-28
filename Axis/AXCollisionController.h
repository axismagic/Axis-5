//
//  AXCollisionController.h
//  Axis
//
//  Created by Jethro Wilson on 27/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXSprite.h"

@interface AXCollisionController : AXSprite {
    NSArray *sceneObjects;
    NSMutableArray *allColliders;
    NSMutableArray *collidersToCheck;
}

@property (retain) NSArray *sceneObjects;

- (void)handleCollisions;

- (void)addObject:(AXSprite*)sceneObject;

- (void)awake;
- (void)render;
- (void)update;

@end
