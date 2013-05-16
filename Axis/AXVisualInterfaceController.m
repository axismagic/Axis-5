//
//  AXInterfaceController.m
//  Axis
//
//  Created by Jethro Wilson on 14/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXVisualInterfaceController.h"

#import "AXSceneController.h"

#import "AXTexturedButton.h"

#import "AXNewScene.h"

@implementation AXVisualInterfaceController

//@synthesize forwardMagnitude, leftMagnitude, rightMagnitude;

- (id)init {
    self = [super init];
    if (self != nil) {
        
    }
    
    return self;
}

- (void)loadInterface {
    if (interfaceObjects == nil)
        interfaceObjects = [[NSMutableArray alloc] init];
    
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
    [rightButton release];
    
    // left arrow button
    // OLD AXButton *leftButton = [[AXArrowButton alloc] init];
    AXTexturedButton *leftButton = [[AXTexturedButton alloc] initWithUpKey:@"leftUp" downKey:@"leftDown"];
    leftButton.scale = AXPointMake(50.0, 50.0, 1.0);
    leftButton.location = AXPointMake(-210.0, -130.0, 0.0);
    //leftButton.rotation = AXPointMake(0.0, 0.0, 180.0);
    // set actions
    leftButton.target = self;
    leftButton.buttonDownAction = @selector(leftButtonDown);
    leftButton.buttonUpAction = @selector(leftButtonUp);
    // activate
    leftButton.active = YES;
    [leftButton awake];
    [interfaceObjects addObject:leftButton];
    [leftButton release];
    
    // forward arrow button
    // OLD AXButton *forwardButton = [[AXArrowButton alloc] init];
    AXTexturedButton *forwardButton = [[AXTexturedButton alloc] initWithUpKey:@"thrustUp" downKey:@"thrustDown"];
    forwardButton.scale = AXPointMake(50.0, 50.0, 1.0);
    forwardButton.location = AXPointMake(-185.0, -75.0, 0.0);
    //forwardButton.rotation = AXPointMake(0.0, 0.0, 90.0);
    // set actions
    forwardButton.target = self;
    forwardButton.buttonDownAction = @selector(forwardButtonDown);
    forwardButton.buttonUpAction = @selector(forwardButtonUp);
    // activate
    forwardButton.active = YES;
    [forwardButton awake];
    [interfaceObjects addObject:forwardButton];
    [forwardButton release];
    
    // fire arrow button
    // OLD AXButton *fireButton = [[AXButton alloc] init];
    AXTexturedButton *fireButton = [[AXTexturedButton alloc] initWithUpKey:@"fireUp" downKey:@"fireDown"];
    fireButton.scale = AXPointMake(50.0, 50.0, 1.0);
    fireButton.location = AXPointMake(210.0, -130.0, 0.0);
    // set actions
    fireButton.target = self;
    fireButton.buttonDownAction = @selector(fireButtonDown);
    fireButton.buttonUpAction = @selector(fireButtonUp);
    // activate
    fireButton.active = YES;
    [fireButton awake];
    [interfaceObjects addObject:fireButton];
    [fireButton release];*/
}

- (void)updateInterface {
    // update interface objects
    [interfaceObjects makeObjectsPerformSelector:@selector(update)];
}

- (void)renderInterface {
    [interfaceObjects makeObjectsPerformSelector:@selector(render)];
}

#pragma mark Input Registers

// ***** should change to delegates?

/*- (void)fireButtonDown {
    AXNewScene *newScene = [[AXNewScene alloc] init];
    [[AXSceneController sharedSceneController] loadScene:newScene forKey:@"rockScene" activate:YES];
    [newScene release];
}

- (void)fireButtonUp {
}

- (void)rightButtonDown {
    self.rightMagnitude = 1.0;
}

- (void)rightButtonUp {
    self.rightMagnitude = 0.0;
}

- (void)leftButtonDown {
    self.leftMagnitude = 1.0;
}

- (void)leftButtonUp {
    self.leftMagnitude = 0.0;
}

- (void)forwardButtonDown {
    self.forwardMagnitude = 1.0;
}

- (void)forwardButtonUp {
    self.forwardMagnitude = 0.0;
}*/

@end
