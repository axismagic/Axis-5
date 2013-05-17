//
//  AXScene.h
//  Axis
//
//  Created by Jethro Wilson on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXObject.h"
#import "AXSprite.h"
#import "AXVisualInterfaceController.h"
#import "AXCollisionController.h"

@interface AXScene : AXObject <AXSceneObjectProtocol, AXVisualInterfaceProtocol> {
    // interfaceController
    AXVisualInterfaceController *_visualInterfaceController;
    // collisionController
    AXCollisionController *_collisionController;
}

@property (nonatomic, retain) AXVisualInterfaceController *visualInterfaceController;
@property (nonatomic, retain) AXCollisionController *collisionController;

- (void)loadScene;

- (void)updateScene;
- (void)renderScene;

@end
