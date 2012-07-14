//
//  AXInterfaceController.m
//  Axis
//
//  Created by Jethro Wilson on 14/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXInterfaceController.h"

#import "AXTexturedButton.h"

#import "AXNewScene.h"

@implementation AXInterfaceController

- (id)init {
    self = [super init];
    if (self != nil) {
        
    }
    
    return self;
}

- (void)loadInterface {
    if (interfaceObjects == nil)
        interfaceObjects = [[NSMutableArray alloc] init];
    
    AXTexturedButton *rightButton = [[AXTexturedButton alloc] initWithUpKey:@"rightUp" downKey:@"rightDown"];
    rightButton.scale = AXPointMake(50.0, 50.0, 1.0);
    rightButton.translation = AXPointMake(-155.0, -130.0, 0.0);
    // set actions
    rightButton.target = self;
    rightButton.buttonDownAction = @selector(rightButtonDown);
    rightButton.buttonUpAction = @selector(rightButtonUp);
    // activate
    rightButton.active = YES;
    [rightButton awake];
    [interfaceObjects addObject:rightButton];
    [rightButton release];
}

- (void)updateInterface {
    [interfaceObjects makeObjectsPerformSelector:@selector(update)];
}

- (void)renderInterface {
    [interfaceObjects makeObjectsPerformSelector:@selector(render)];
}

#pragma mark Input Registers

// ***** should change to delegates?

- (void)rightButtonDown {
    // self.rightMagnitude = 1.0;
    AXNewScene *newScene = [[AXNewScene alloc] init];
    [[AXSceneController sharedSceneController] loadScene:newScene activate:YES];
    [newScene release];
}

- (void)rightButtonUp {
    // self.rightMagnitude = 0.0;
}

@end
