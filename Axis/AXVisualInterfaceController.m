//
//  AXVisualInterfaceController.m
//  Axis
//
//  Created by Jethro Wilson on 14/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXVisualInterfaceController.h"

#import "AXDirector.h"

#import "AXTexturedButton.h"

#import "AXNewScene.h"

@implementation AXVisualInterfaceController

- (id)init {
    self = [super init];
    if (self != nil) {
        
    }
    
    return self;
}

- (void)dealloc {
    // unregister touches
    [[AXDirector sharedDirector].inputController unregisterObjectForTouches:self];
    [super dealloc];
}

- (void)activate {
    [super activate];
    [[AXDirector sharedDirector].inputController registerObjectForTouches:self];
}

- (void)loadInterface {
    if (children == nil)
        children = [[NSMutableArray alloc] init];
    
    /*AXTexturedButton *rightButton = [[AXTexturedButton alloc] initWithUpKey:@"rightUp" downKey:@"rightDown"];
    rightButton.scale = AXPointMake(50.0, 50.0, 1.0);
    rightButton.location = AXPointMake(-155.0, -130.0, 0.0);
    // set actions
    rightButton.target = self;
    rightButton.buttonDownAction = @selector(rightButtonDown);
    rightButton.buttonUpAction = @selector(rightButtonUp);
    // activate
    rightButton.active = YES;
    [rightButton awake];
    [interfaceObjects addObject:rightButton];
    [rightButton release];*/
}

// no update or render as is taken care of in AXObject

#pragma mark - Touches

- (void)axTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in [touches allObjects]) {
        if (touch.phase == UITouchPhaseBegan) {
            NSLog(@"Touch Began");
        }
        
        CGPoint touchPoint = [touch locationInView:[touch view]];
        // correct y coordinate
        // ***** This corrections needs to happen within input controller (or it needs a method which returns correct y coord)
        
        // get touch location
        CGSize correctorFloat = [[AXDirector sharedDirector] viewSize];
        
        AXPoint touchPointLoc = AXPointMake(touchPoint.x, correctorFloat.height-touchPoint.y, 0);
        
        [_sceneDelegate updateWithTouchLocation:touchPointLoc];
    }
}

- (void)axTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in [touches allObjects]) {
        if (touch.phase == UITouchPhaseMoved) {
            NSLog(@"Touch Moved");
        }
    }
}

- (void)axTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in [touches allObjects]) {
        if (touch.phase == UITouchPhaseEnded) {
            NSLog(@"Touch Ended");
        }
    }
}

- (void)axTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in [touches allObjects]) {
        if (touch.phase == UITouchPhaseCancelled) {
            NSLog(@"Touch Cancelled");
        }
    }
}

@end
