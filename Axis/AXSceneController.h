//
//  AXSceneController.h
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AXInputViewController;
@class AXCollisionController;
@class EAGLView;
@class AXSceneObject;

@interface AXSceneController : NSObject {
    NSMutableArray *sceneObjects;
    NSMutableArray *objectsToAdd;
    NSMutableArray *objectsToRemove;
    
    EAGLView *openGLView;
    AXInputViewController *inputController;
    AXCollisionController *collisionController;
    
    CADisplayLink *displayLink;
    
    NSTimer *animationTimer;
    NSTimeInterval animationInterval;
    
    NSDate *levelStartDate;
    
    NSTimeInterval deltaTime;
    NSTimeInterval lastFrameStartTime;
    NSTimeInterval thisFrameStartTime;
}

@property (retain) AXInputViewController *inputController;
@property (retain) EAGLView *openGLView;

@property (retain) NSDate *levelStartDate;
@property NSTimeInterval animationInterval;
@property NSTimeInterval deltaTime;
@property (nonatomic, assign) NSTimer *animationTimer;

+ (AXSceneController*)sharedSceneController;
- (void)dealloc;
- (void)loadScene;
- (void)startScene;
- (void)gameLoop;
- (void)renderScene;
- (void)setAnimationInterval:(NSTimeInterval)interval;
- (void)setAnimationTimer:(NSTimer*)newTimer;
- (void)startAnimation;
- (void)stopAnimation;
- (void)updateModel;

- (void)addObjectToScene:(AXSceneObject*)sceneObject;
- (void)removeObjectFromScene:(AXSceneObject*)sceneObject;

// game specific
- (void)generateRocks;

@end
