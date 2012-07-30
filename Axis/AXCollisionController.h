//
//  AXCollisionController.h
//  Axis
//
//  Created by Jethro Wilson on 27/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXSprite.h"

@interface AXCollisionController : AXSprite {
    NSMutableArray *allColliders;
    NSMutableArray *collidersToCheck;
    
    NSMutableArray *allCollidersToAdd;
    NSMutableArray *allCollidersToRemove;
    NSMutableArray *collidersToCheckToAdd;
    NSMutableArray *collidersToCheckToRemove;
}

- (void)handleCollisions;

- (void)addObject:(AXSprite*)object;
- (void)removeObject:(AXSprite*)object;

- (void)awake;
- (void)render;
- (void)update;

@end
