//
//  AXScene.m
//  Axis
//
//  Created by Jethro Wilson on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXScene.h"

#import "AXVisualInterfaceController.h"
#import "AXCollisionController.h"
#import "AXSprite.h"

@implementation AXScene

@synthesize visualInterfaceController = _visualInterfaceController, collisionController = _collisionController;

- (void)dealloc {
    self.collisionController = nil;
    self.visualInterfaceController = nil;
    [super dealloc];
}

#pragma mark Load

- (id)init {
    self = [super init];
    if (self != nil) {
        self.updates = NO;
        
        self.sceneDelegate = self;
    }
    
    return self;
}

- (void)loadScene {
    if (children == nil)
        children = [[NSMutableArray alloc] init];
    
    // set delegates
    self.sceneDelegate = self;
    self.parentDelegate = self;
    
    // load collisionController
    AXCollisionController *aCollisionController = [[AXCollisionController alloc] init];
    self.collisionController = aCollisionController;
    [aCollisionController release];
    [self.collisionController activate];
    // debug draw colliders
    if (AX_DEBUG_DRAW_COLLIDERS)
        [self addChild:_collisionController];
    
    // load interface
    AXVisualInterfaceController *aVisualInterfaceController = [[AXVisualInterfaceController alloc] init];
    self.visualInterfaceController = aVisualInterfaceController;
    [aVisualInterfaceController release];
    [_visualInterfaceController setSceneDelegate:self];
    [_visualInterfaceController setParentDelegate:self];
    [_visualInterfaceController activate];
    [_visualInterfaceController loadInterface];
}

#pragma mark Updates

- (void)updateScene {
    // update interface
    if (_visualInterfaceController.updates)
        [_visualInterfaceController updateWithMatrix:self.matrix];
    
    // update all other objects
    //[children makeObjectsPerformSelector:@selector(update)];
    //[children makeObjectsPerformSelector:@selector(updateWithMatrix:) withObject:self.matrix];
    for (AXObject *child in children) {
        [child updateWithMatrix:self.matrix];
    }
    
    // handle collisions
    [_collisionController handleCollisions];
    
    // add new objects
    if ([childrenToAdd count] > 0) {
        //[sceneObjects addObjectsFromArray:objectsToAdd];
        [children addObjectsFromArray:childrenToAdd];
        [childrenToAdd removeAllObjects];
    }
    
    // remove old objects
    if ([childrenToRemove count] > 0) {
        [children removeObjectsInArray:childrenToRemove];
        [childrenToRemove removeAllObjects];
    }
}

- (void)renderScene {
    // render all objects
    [children makeObjectsPerformSelector:@selector(render)];
    
    // render interface above the scene
    if (_visualInterfaceController.renders)
        [_visualInterfaceController render];
}

#pragma mark Child Control

/* Overridden addChild to ensure sceneDelegate is correct */
/* ***** no need to override addChild anymore as init method turns _scene delegate to self */
/*- (void)addChild:(AXObject *)child {
    if (childrenToAdd == nil)
        childrenToAdd = [[NSMutableArray alloc] init];
    
    // if child is not already owned, add new child
    NSAssert(!child.isChild, @"Child must not be owned");
    
    // activate ***** consider at end?
    child.active = YES;
    child.isChild = YES;
    if (!_hasChildren)
        self.hasChildren = YES;
    
    // delegate
    child.sceneDelegate = self; // ***** difference between normal and overridden.
    child.parentDelegate = self;
    
    // awake child
    [child awake];
    // add to children array
    [childrenToAdd addObject:child];
}*/

/* 
 No need to override removeChild:(AXObject*)object
 */

#pragma mark -
#pragma mark Scene Object Ownership Delegate Methods

/*
 This method is called by the parent of an object as it adds the object. It evaluates the objects and decides which controllers the scene needs to add it to for tracking and other purposes. Any other features can also take place here. At this moment the object is fully initialised and in use.
*/
- (void)addObjectCollider:(AXObject*)object {
    if (![object isKindOfClass:[AXSprite class]])
        return;
    
    // add the object to the collision controller
    if (object != _collisionController)
        [_collisionController addObject:(AXSprite*)object]; 
}

- (void)removeObjectCollider:(AXObject*)object {
    if (![object isKindOfClass:[AXSprite class]])
        return;
    
    if (object != _collisionController)
        [_collisionController removeObject:(AXSprite*)object];
}

// add or remove things directly to the scene
- (void)addObjectToScene:(AXObject *)object {
    [self addChild:object];
}

- (void)removeObjectFromScene:(AXObject *)object {
    [self removeChild:object];
}

@end