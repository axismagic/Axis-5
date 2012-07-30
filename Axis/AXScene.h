//
//  AXScene.h
//  Axis
//
//  Created by Jethro Wilson on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXObject.h"
#import "AXSprite.h"
#import "AXInterfaceController.h"
#import "AXCollisionController.h"

@interface AXScene : AXObject <AXSceneObjectProtocol> {
    // should update, even when not active?
    BOOL updates;
    
    // scene object management
    //NSMutableArray *sceneObjects;
    //NSMutableArray *objectsToAdd;
    //NSMutableArray *objectsToRemove;
    
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

//- (void)addObjectToScene:(AXSprite*)sceneObject;
//- (void)removeObjectFromScene:(AXSprite*)sceneObject;

@end
