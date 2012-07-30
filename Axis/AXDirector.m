//
//  AXDirector.m
//  Axis
//
//  Created by Jethro Wilson on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXDirector.h"
#import "AXConfiguration.h"
#import "AXInputViewController.h"
#import "AXCollisionController.h"
#import "EAGLView.h"

#import "AXNewScene.h"

@implementation AXDirector

+ (AXDirector*)sharedDirector {
    static AXDirector *sharedDirector;
    @synchronized(self) {
        if (!sharedDirector)
            sharedDirector = [[AXDirector alloc] init];
    }
    
    return  sharedDirector;
}

- (void)setupEngine {
    // sets up the Scene Controller and Input Controller
    AXSceneController *sceneController = [AXSceneController sharedSceneController];
    
    // Create a new scene
    AXNewScene *scene = [[AXNewScene alloc] init];
    [sceneController loadScene:scene forKey:@"newScene" activate:YES];
    [scene release];
    // Starts the main loop which updates and renders scenes
    [sceneController startLoop];
}

- (void)dealloc {
    [super dealloc];
}

@end
