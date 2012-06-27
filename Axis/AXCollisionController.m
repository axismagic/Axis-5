//
//  AXCollisionController.m
//  Axis
//
//  Created by Jethro Wilson on 27/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXCollisionController.h"
#import "AXMobileObject.h"
#import "AXCollider.h"

@implementation AXCollisionController

@synthesize sceneObjects;

- (void)handleCollisions {
    if (allColliders == nil)
        allColliders = [[NSMutableArray alloc] init];
    [allColliders removeAllObjects];
    if (collidersToCheck == nil)
        collidersToCheck = [[NSMutableArray alloc] init];
    [collidersToCheck removeAllObjects];
    
    // build arrays
    for (AXSceneObject *obj in sceneObjects) {
        if (obj.collider != nil) {
            [allColliders addObject:obj];
            if (obj.collider.checkForCollisions)
                [collidersToCheck addObject:obj];
        }
    }
    
    // collisions check
    for (AXSceneObject *colliderObject in collidersToCheck) {
        for (AXSceneObject *collideeObject in allColliders) {
            if (colliderObject == collideeObject)
                continue;
            if ([colliderObject.collider doesCollideWithCollider:collideeObject.collider]) {
                if ([colliderObject respondsToSelector:@selector(didCollideWith:)])
                    [colliderObject didCollideWith:collideeObject];
            }
        }
    }
}

- (void)awake {
    
}

- (void)update {
    
}

- (void)render {
    if (!active)
        return;
    glPushMatrix();
    glLoadIdentity();
    for (AXSceneObject *obj in allColliders) {
        [obj.collider render];
    }
    glPopMatrix();
}

@end
