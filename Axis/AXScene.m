//
//  AXScene.m
//  Axis
//
//  Created by Jethro Wilson on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXScene.h"

#import "AXInterfaceController.h"
#import "AXSceneObject.h"

#import "AXSpaceShip.h"

@implementation AXScene

@synthesize shouldUpdate, active;
@synthesize interfaceController;

#pragma mark Load

- (id)init {
    self = [super init];
    if (self != nil) {
        shouldUpdate = NO;
        active = NO;
    }
    
    return self;
}

- (void)loadScene {
    if (sceneObjects == nil)
        sceneObjects = [[NSMutableArray alloc] init];
    
    // create the ship
    AXSpaceShip *ship = [[AXSpaceShip alloc] init];
    [self addObjectToScene:ship];
    [ship release];
    
    // load interface
    interfaceController = [[AXInterfaceController alloc] init];
    [interfaceController loadInterface];
}

#pragma mark Updates

- (void)updateModel {
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
}

- (void)removeObjectFromScene:(AXSceneObject*)sceneObject {
    if (objectsToRemove == nil)
        objectsToRemove = [[NSMutableArray alloc] init];
    [objectsToRemove addObject:sceneObject];
}



@end
