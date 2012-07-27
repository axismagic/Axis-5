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
#import "AXSceneObject.h"

#import "AXSpaceShip.h"
#import "AXRock.h"

@implementation AXScene

@synthesize updates;
@synthesize interfaceController, collisionController;

#pragma mark Load

- (id)init {
    self = [super init];
    if (self != nil) {
        self.updates = NO;
    }
    
    return self;
}

- (void)loadScene {
    if (sceneObjects == nil)
        sceneObjects = [[NSMutableArray alloc] init];
    
    // load collisionController
    collisionController = [[AXCollisionController alloc] init];
    if (AX_DEBUG_DRAW_COLLIDERS)
        [self addObjectToScene:collisionController];
    
    // create the ship
    AXSpaceShip *ship = [[AXSpaceShip alloc] init];
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
    [ship release];
    
    // load interface
    interfaceController = [[AXInterfaceController alloc] init];
    [interfaceController loadInterface];
}

#pragma mark Updates

- (void)updateScene {
    // add new objects
    if ([objectsToAdd count] > 0) {
        [sceneObjects addObjectsFromArray:objectsToAdd];
        [objectsToAdd removeAllObjects];
    }
    
    // update interface
    // ***** only if is active?
    // if (active)
    [interfaceController updateInterface];
    
    // update all objects
    [sceneObjects makeObjectsPerformSelector:@selector(update)];
    
    // handle collisions
    [collisionController handleCollisions];
    
    // ***** render and object remove order?
    
    // remove old objects
    if ([objectsToRemove count] > 0) {
        [sceneObjects removeObjectsInArray:objectsToRemove];
        [objectsToRemove removeAllObjects];
    }
}

- (void)renderScene {
    // render all objects
    [sceneObjects makeObjectsPerformSelector:@selector(render)];
    
    // render interface above the scene
    [interfaceController renderInterface];
}

- (void)addObjectToScene:(AXSceneObject*)sceneObject {
    if (objectsToAdd == nil)
        objectsToAdd = [[NSMutableArray alloc] init];
    
    // activate and wake object
    sceneObject.active = YES;
    [sceneObject awake];
    [objectsToAdd addObject:sceneObject];
    
    // set object delegate
    sceneObject.delegate = self;
    
    // ***** consider re-order
    [sceneObject finalAwake];
    
    /*if (sceneObject != collisionController)
        [collisionController addObject:sceneObject];*/
}

- (void)removeObjectFromScene:(AXSceneObject*)sceneObject {
    if (objectsToRemove == nil)
        objectsToRemove = [[NSMutableArray alloc] init];
    [objectsToRemove addObject:sceneObject];
}

#pragma mark -
#pragma mark Scene Object Ownership Delegate Methods

/*
 This method is called by the parent of an object as it adds the object. It evaluates the objects and decides which controllers the scene needs to add it to for tracking and other purposes. Any other features can also take place here. At this moment the object is fully initialised and in use.
*/
- (void)submitForEvaluation:(AXSceneObject *)object {
    // add the object to the collision controller
    if (object != collisionController)
        [collisionController addObject:object]; 
}

@end