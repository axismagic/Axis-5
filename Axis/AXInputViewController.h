//
//  AXInputViewControllerViewController.h
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXInputProtocol.h"
#import "AXObject.h"

@interface AXInputViewController : UIViewController {
    BOOL _inputActive;
    
    NSMutableSet *_touchEvents;
    
    NSMutableSet *_registeredObjects;
}

@property (nonatomic, assign) BOOL inputActive;

- (void)registerObjectForTouches:(AXObject*)object;
- (void)unregisterObjectForTouches:(AXObject*)object;

//

- (void)touches:(NSSet*)touches withEvent:(UIEvent*)event;

- (void)clearEvents;
- (void)didReceiveMemoryWarning;
- (void)loadView;
- (void)viewDidUnload;
- (void)dealloc;

// *R?*
- (CGRect)screenRectFromMeshRect:(CGRect)rect atPoint:(CGPoint)meshCenter;

@end
