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

#import "AXScene.h"

@implementation AXDirector

@synthesize inputController, openGLView;
@synthesize animationTimer, animationInterval;
@synthesize levelStartDate, deltaTime;
@synthesize viewSize;

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
    
    /*
     *****
     tells sceneController initial frame rate
     tells sceneController which scene to load
     sets up sceneController with other basic settings
    */
    AXScene *scene = [[AXScene alloc] init];
    [sceneController loadScene:scene activate:YES]; // change to loadScene:(AXScene*)scene;
    [scene release];
    // starts scene once ready
    // ***** [sceneController startScene];
    [sceneController startLoop]; // starts the scene loop which updates scenes
    /* change to
     sceneController loadScene:firstScene - this loads the scene into the array of scenes NOTE doesn't make it active
     sceneController activeScene:firstScene - this makes the first scene the active scene which will render
     sceneController startLoop
     
     CONSIDER - loadScene:(AXScene*)scene activate:(BOOL)activate
    */
}

@end
