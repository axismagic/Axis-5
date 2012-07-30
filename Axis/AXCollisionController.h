//
//  AXCollisionController.h
//  Axis
//
//  Created by Jethro Wilson on 27/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXSprite.h"

@interface AXCollisionController : AXSprite {
    //NSArray *sceneObjects;
    NSMutableArray *allColliders;
    NSMutableArray *collidersToCheck;
    
    NSMutableArray *allCollidersToAdd;
    NSMutableArray *allCollidersToRemove;
    NSMutableArray *collidersToCheckToAdd;
    NSMutableArray *collidersToCheckToRemove;
}

@property (retain) NSArray *sceneObjects;

- (void)handleCollisions;

- (void)addObject:(AXSprite*)object;
- (void)removeObject:(AXSprite*)object;

- (void)awake;
- (void)render;
- (void)update;

@end
