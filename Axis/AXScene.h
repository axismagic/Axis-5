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
    BOOL _updates;
    
    // interfaceController
    AXInterfaceController *_interfaceController;
    // collisionController
    AXCollisionController *_collisionController;
}

@property (nonatomic, assign) BOOL updates;

@property (nonatomic, retain) AXInterfaceController *interfaceController;
@property (nonatomic, retain) AXCollisionController *collisionController;

- (void)loadScene;

- (void)updateScene;
- (void)renderScene;

@end
