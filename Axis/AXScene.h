//
//  AXScene.h
//  Axis
//
//  Created by Jethro Wilson on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AXInterfaceController;
@class AXSceneObject;

@interface AXScene : NSObject {
    // should update, even when not active?
    BOOL shouldUpdate;
    // is active?
    BOOL active;
    
    // scene object management
    NSMutableArray *sceneObjects;
    NSMutableArray *objectsToAdd;
    NSMutableArray *objectsToRemove;
    
    // interfaceController
    AXInterfaceController *interfaceController;
}

@property (assign) BOOL shouldUpdate;
@property (assign) BOOL active;

@property (retain) AXInterfaceController *interfaceController;

- (void)loadScene;

- (void)updateModel;
- (void)renderScene;

- (void)addObjectToScene:(AXSceneObject*)sceneObject;
- (void)removeObjectFromScene:(AXSceneObject*)sceneObject;

@end
