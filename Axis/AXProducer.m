//
//  AXProducer.m
//  Axis
//
//  Created by Jethro Wilson on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXProducer.h"
#import "AXConfiguration.h"
#import "AXInputViewController.h"
#import "AXCollisionController.h"
#import "EAGLView.h"

#import "AXNewScene.h"

@implementation AXProducer

+ (AXProducer*)sharedProducer {
    static AXProducer *sharedProducer;
    @synchronized(self) {
        if (!sharedProducer)
            sharedProducer = [[AXProducer alloc] init];
    }
    
    return  sharedProducer;
}

- (void)setupEngine {
    // gets the Scene Controller
    AXSceneController *sceneController = [AXSceneController sharedSceneController];
    
    // Create first scene
    AXNewScene *scene = [[AXNewScene alloc] init];
    // tell scene controller to load the scene
    [sceneController loadScene:scene forKey:@"newScene" activate:YES];
    [scene release];
    // Starts the main loop which updates and renders scenes
    [sceneController startLoop];
}

- (void)dealloc {
    [super dealloc];
}

@end
