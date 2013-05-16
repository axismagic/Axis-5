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
    // gets the Director
    AXDirector *director = [AXDirector sharedDirector];
    
    // Create first scene
    AXNewScene *scene = [[AXNewScene alloc] init];
    // tell director to load the scene
    [director loadScene:scene forKey:@"newScene" activate:YES];
    [scene release];
    // Starts the main loop which updates and renders scenes
    [director startLoop];
}

- (void)dealloc {
    [super dealloc];
}

@end
