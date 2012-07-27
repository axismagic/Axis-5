//
//  AXScene.h
//  Axis
//
//  Created by Jethro Wilson on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXSceneObject.h"

@class AXInterfaceController;
@class AXCollisionController;

@interface AXScene : NSObject <sceneObjectOwnership> {
    // should update, even when not active?
    BOOL updates;
    
    // scene object management
    NSMutableArray *sceneObjects;
    NSMutableArray *objectsToAdd;
    NSMutableArray *objectsToRemove;
    
    // interfaceController
    AXInterfaceController *interfaceController;
    // collisionController
    AXCollisionController *collisionController;
}

@property (assign) BOOL updates;

@property (retain) AXInterfaceController *interfaceController;
@property (retain) AXCollisionController *collisionController;

- (void)loadScene;

- (void)updateScene;
- (void)renderScene;

- (void)addObjectToScene:(AXSceneObject*)sceneObject;
- (void)removeObjectFromScene:(AXSceneObject*)sceneObject;

@end
