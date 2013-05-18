//
//  AXVisualInterfaceController.h
//  Axis
//
//  Created by Jethro Wilson on 14/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXObject.h"

@class AXDynamicJoyStick;
@class AXActionButton;

@protocol AXVisualInterfaceProtocol <AXSceneObjectProtocol>

@optional
// your messages back to scene
- (void)updateWithTouchLocation:(AXPoint)location;
- (void)actionoccured:(BOOL)action;

@end

@interface AXVisualInterfaceController : AXObject {
    AXDynamicJoyStick *_leftStick;
    AXActionButton *_actionButton;
}

@property (nonatomic, retain) AXScene <AXVisualInterfaceProtocol> *sceneDelegate;
@property (nonatomic, retain) AXDynamicJoyStick *leftStick;
@property (nonatomic, retain) AXActionButton *actionButton;

- (void)loadInterface;

@end