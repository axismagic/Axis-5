//
//  AXVisualInterfaceController.h
//  Axis
//
//  Created by Jethro Wilson on 14/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXObject.h"

@protocol AXVisualInterfaceProtocol <AXSceneObjectProtocol>

@optional
// your messages back to scene
- (void)updateWithTouchLocation:(AXPoint)location;

@end

@interface AXVisualInterfaceController : AXObject {
    
}

@property (nonatomic, retain) AXScene <AXVisualInterfaceProtocol> *sceneDelegate;

- (void)loadInterface;

@end