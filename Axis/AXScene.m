//
//  AXScene.m
//  Axis
//
//  Created by Jethro Wilson on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXScene.h"

#import "AXInterfaceController.h"
#import "AXCollisionController.h"
#import "AXSprite.h"

@implementation AXScene

@synthesize interfaceController = _interfaceController, collisionController = _collisionController;

- (void)dealloc {
    self.collisionController = nil;
    self.interfaceController = nil;
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
    
    if (AX_DEBUG_DRAW_COLLIDERS)
        //[self addObjectToScene:collisionController];
        [self addChild:_collisionController];
    
    // load interface
    // AXInterfaceController *anInterfaceController = [[AXInterfaceController alloc] init];
    // self.interfaceController = anInterfaceController;
    // [anInterfaceController release];
    // [_interfaceController loadInterface];
    
    // create the ship
    /*AXSpaceShip *ship = [[AXSpaceShip alloc] init];
    ship.speed = AXPointMake(0.2, 0.2, 0.0);
    ship.rotationalSpeed = AXPointMake(0.0, 0.0, 0.2);
    [self addObjectToScene:ship];
    [ship release];
    
    // create child rock
    AXRock *rocksecond = [AXRock randomRock];
    rocksecond.translation = AXPointMake(ship.translation.x, ship.translation.y - 100, 0.0);
    rocksecond.rotationalSpeed = AXPointMake(0.0, 0.0, 0.0);
    rocksecond.speed = AXPointMake(0.2, 0.0, 0.0);
    [ship addChild:rocksecond];
    
    // create child rock
    AXRock *rock = [AXRock randomRock];
    rock.translation = AXPointMake(ship.translation.x, ship.translation.y + 100, 0.0);
    rock.rotationalSpeed = AXPointMake(0.0, 0.0, 0.0);
    rock.speed = AXPointMake(0.2, 0.0, 0.0);
    [ship addChild:rock];
    
    // release the ship
    [ship release];*/
}

#pragma mark Updates

- (void)updateScene {
    // add new objects
    if ([childrenToAdd count] > 0) {
        //[sceneObjects addObjectsFromArray:objectsToAdd];
        [children addObjectsFromArray:childrenToAdd];
        [childrenToAdd removeAllObjects];
    }
    
    // update interface
    // ***** only if is active?
    // if (active)
    [_interfaceController updateInterface];
    
    // update all objects
    //[sceneObjects makeObjectsPerformSelector:@selector(update)];
    [children makeObjectsPerformSelector:@selector(update)];
    
    // handle collisions
    [_collisionController handleCollisions];
    
    // ***** render and object remove order?
    
    // remove old objects
    if ([childrenToRemove count] > 0) {
        [children removeObjectsInArray:childrenToRemove];
        [childrenToRemove removeAllObjects];
    }
}

- (void)renderScene {
    // render all objects
    //[sceneObjects makeObjectsPerformSelector:@selector(render)];
    [children makeObjectsPerformSelector:@selector(render)];
    
    // render interface above the scene
    [_interfaceController renderInterface];
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

// used to add or remove things directly to the scene
- (void)addObjectToScene:(AXObject *)object {
    [self addChild:object];
}

- (void)removeObjectFromScene:(AXObject *)object {
    [self removeChild:object];
}

@end