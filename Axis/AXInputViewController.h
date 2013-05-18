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
    NSMutableSet *_registeredSwallowingObjects;
    NSMutableSet *_registeredRemainingObjects;
    
    NSMutableSet *_handlersToAdd;
    NSMutableSet *_handlersToRemove;
    
    BOOL _loopLock;
}

@property (nonatomic, assign) BOOL inputActive;
@property (nonatomic, assign) BOOL loopLock;

- (void)registerObjectForTouches:(AXObject *)object swallowsTouchesType:(AXInputObjectSwallowType)swallowType;
- (void)unregisterObjectForTouches:(AXObject*)object;
- (void)unregisterObjectForTouches:(AXObject *)object swallowsTouchesType:(AXInputObjectSwallowType)swallowType;

//

- (void)touches:(NSSet *)touches withEvent:(UIEvent *)event touchTypeSelector:(SEL)touchTypeSelector;

- (void)didReceiveMemoryWarning;
- (void)loadView;
- (void)viewDidUnload;
- (void)dealloc;

// *R?*
- (CGRect)screenRectFromMeshRect:(CGRect)rect atPoint:(CGPoint)meshCenter;

@end
