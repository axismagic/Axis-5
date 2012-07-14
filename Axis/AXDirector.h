//
//  AXDirector.h
//  Axis
//
//  Created by Jethro Wilson on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AXInputViewController;
@class AXCollisionController;
@class AXSceneController;
@class EAGLView;

@interface AXDirector : NSObject {
    NSMutableDictionary *scenes;
    NSMutableDictionary *scenesToAdd;
    NSMutableDictionary *scenesToRemove;
    
    EAGLView *openGLView;
    AXInputViewController *inputController;
    //AXSceneController *sceneController;
    // ***** For AXSceneController 
    // AXCollisionController *collisionController;
    
    // global access
    CGSize viewSize;
    
    // display and animation variables
    
    // ***** for sceneController
    CADisplayLink *displayLink;
    
    NSTimer *animationTimer;
    NSTimeInterval animationInterval;
    
    NSDate *levelStartDate;
    
    NSTimeInterval deltaTime;
    NSTimeInterval lastFrameStartTime;
    NSTimeInterval thisFrameStartTime;
    
    //
}

@property (retain) AXInputViewController *inputController;
//@property (retain) AXSceneController *sceneController;
@property (retain) EAGLView *openGLView;

@property (assign) CGSize viewSize;

@property (retain) NSDate *levelStartDate;
@property NSTimeInterval animationInterval;
@property NSTimeInterval deltaTime;
@property (nonatomic, assign) NSTimer *animationTimer;

/*- (void)loadScene;
- (void)startScene;
- (void)gameLoop;
- (void)renderScene;*/
- (void)setAnimationInterval:(NSTimeInterval)interval;
- (void)setAnimationTimer:(NSTimer*)newTimer;
- (void)startAnimation;
- (void)stopAnimation;

//

+ (AXDirector*)sharedDirector;
- (void)setupEngine;


// job for sceneController
- (void)addScene;
- (void)removeScene;
- (void)showScene;

- (void)dealloc;

@end
