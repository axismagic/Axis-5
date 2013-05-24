//
//  AXVisualInterfaceController.m
//  Axis
//
//  Created by Jethro Wilson on 14/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXVisualInterfaceController.h"

#import "AXDirector.h"

#import "AXDynamicJoyStick.h"
#import "AXActionButton.h"
#import "AXSprite.h"

@interface AXVisualInterfaceController ()

@end

@implementation AXVisualInterfaceController

@synthesize leftStick = _leftStick;
@synthesize actionButton = _actionButton;

- (id)init {
    self = [super init];
    if (self != nil) {
        
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)loadInterface {
    if (children == nil)
        children = [[NSMutableArray alloc] init];
    
    self.leftStick = [[AXDynamicJoyStick alloc] init];
    self.leftStick.location = AXPointMake(100, 100, 0);
    [self addChild:self.leftStick];
    [self.leftStick activate];
    
    self.actionButton = [[AXActionButton alloc] initWithSpriteImage:@"thumbStick"];
    self.actionButton.location = AXPointMake(450, 100, 0);
    [self addChild:self.actionButton];
    [self.actionButton activate];
    
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

/* *R?* - (void)update {
    if (!_active)
        return;
    
    [super update];
    // update scene delegate with touch updates
    [self.sceneDelegate updateWithTouchLocation:AXPointMake(self.leftStick.movementPower.x, self.leftStick.movementPower.y, 0)];
    [self.sceneDelegate actionoccured:self.actionButton.actionOn];
}*/

- (void)endUpdate {
    // update scene delegate with touch updates
    [self.sceneDelegate updateWithTouchLocation:AXPointMake(self.leftStick.movementPower.x, self.leftStick.movementPower.y, 0)];
    [self.sceneDelegate actionoccured:self.actionButton.actionOn];
}

@end
