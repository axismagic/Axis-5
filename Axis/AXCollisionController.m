//
//  AXCollisionController.m
//  Axis
//
//  Created by Jethro Wilson on 27/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXCollisionController.h"
#import "AXCollider.h"

@implementation AXCollisionController

- (void)handleCollisions {
    
    /* rather than collision controller getting the objects, objects are submitted to the controller by their parent object
    */
    /*if (allColliders == nil)
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
    }*/
    
    // add new colliders
    if ([allCollidersToAdd count] > 0) {
        if (allColliders == nil)
            allColliders = [[NSMutableArray alloc] init];
        [allColliders addObjectsFromArray:allCollidersToAdd];
        [allCollidersToAdd removeAllObjects];
    }
    if ([collidersToCheckToAdd count] > 0) {
        if (collidersToCheck == nil)
            collidersToCheck = [[NSMutableArray alloc] init];
        [collidersToCheck addObjectsFromArray:collidersToCheckToAdd];
        [collidersToCheckToAdd removeAllObjects];
    }
    
    // collisions check
    for (AXSprite *colliderObject in collidersToCheck) {
        for (AXSprite *collideeObject in allColliders) {
            if (colliderObject == collideeObject)
                // same object, skip to next loop
                continue;
            if ([colliderObject.collider doesCollideWithCollider:collideeObject.collider]) {
                if ([colliderObject respondsToSelector:@selector(didCollideWith:)])
                    [colliderObject didCollideWith:collideeObject];
            }
        }
    }
    
    // remove old colliders
    if ([allCollidersToRemove count] > 0) {
        [allColliders removeObjectsInArray:allCollidersToRemove];
        [allCollidersToRemove removeAllObjects];
    }
    if ([collidersToCheckToRemove count] > 0) {
        [collidersToCheck removeObjectsInArray:collidersToCheckToRemove];
        [collidersToCheckToRemove removeAllObjects];
    }
}

- (void)addObject:(AXSprite*)object {
    // initialise arrays
    if (allCollidersToAdd == nil)
        allCollidersToAdd = [[NSMutableArray alloc] init];
    if (collidersToCheckToAdd == nil)
        collidersToCheckToAdd = [[NSMutableArray alloc] init];
    
    if (object.collider != nil) {
        // if has collider, add to allColliders
        [allCollidersToAdd addObject:object];
        if (object.collider.checkForCollisions)
            // if collider needs checking, add to check
            [collidersToCheckToAdd addObject:object];
    }
}

- (void)removeObject:(AXSprite*)object {
    // initialise arrays
    if (allCollidersToRemove == nil)
        allCollidersToRemove = [[NSMutableArray alloc] init];
    if (collidersToCheckToRemove == nil)
        collidersToCheckToRemove = [[NSMutableArray alloc] init];
    
    if (object.collider != nil) {
        // if object has collider, remove it
        [allCollidersToRemove addObject:object];
        if (object.collider.checkForCollisions)
            // if collider needs checking, remove that too
            [collidersToCheckToRemove addObject:object];
    }
}

- (void)awake {
    
}

/* *R?*- (void)update {
    [super update];
}*/

- (void)render {
    if (!_active)
        return;
    glPushMatrix();
    glLoadIdentity();
    for (AXSprite *obj in allColliders) {
        [obj.collider render];
    }
    glPopMatrix();
}

@end
