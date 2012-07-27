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
    
    // collisions check
    for (AXSceneObject *colliderObject in collidersToCheck) {
        for (AXSceneObject *collideeObject in allColliders) {
            if (colliderObject == collideeObject)
                // same object, skip to next loop
                continue;
            if ([colliderObject.collider doesCollideWithCollider:collideeObject.collider]) {
                if ([colliderObject respondsToSelector:@selector(didCollideWith:)])
                    [colliderObject didCollideWith:collideeObject];
            }
        }
    }
}

- (void)addObject:(AXSceneObject*)sceneObject {
    // initialise arrays
    if (allColliders == nil)
        allColliders = [[NSMutableArray alloc] init];
    if (collidersToCheck == nil)
        collidersToCheck = [[NSMutableArray alloc] init];
    
    if (sceneObject.collider != nil) {
        // if has collider, add to allColliders
        [allColliders addObject:sceneObject];
        if (sceneObject.collider.checkForCollisions)
            // if collider needs checking, add to check
            [collidersToCheck addObject:sceneObject];
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
