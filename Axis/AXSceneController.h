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
@class AXScene;

@interface AXSceneController : NSObject {
    
    NSMutableArray *scenes;
    
    // OpenGL View
    EAGLView *openGLView;
    // Input Controller
    AXInputViewController *inputController;
    // Collision Controller ***** should move to scene?
    /*
     To avoid all sceneObjects from all scenes being checked when only one is active, collisions should be moved to individual scenes.
     Should same happen for inputController? No, active BOOL stops scenes from doing anything with touches. Should.
    */
    AXCollisionController *collisionController;
    
    // Loop tracking
    CADisplayLink *displayLink;
    
    NSTimer *animationTimer;
    NSTimeInterval animationInterval;
    
    NSDate *startDate;
    
    NSTimeInterval deltaTime;
    NSTimeInterval lastFrameStartTime;
    NSTimeInterval thisFrameStartTime;
    
    NSMutableArray *scenesToAdd;
    NSMutableArray *scenesToRemove;
    
    //
    
    
    /*NSMutableArray *sceneObjects;
    NSMutableArray *objectsToAdd;
    NSMutableArray *objectsToRemove;
    
    CGSize viewSize;*/
    
    
}

@property (retain) AXInputViewController *inputController;
@property (retain) EAGLView *openGLView;

@property (assign) CGSize viewSize;

@property (retain) NSDate *startDate;
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

- (void)loadScene:(AXScene*)scene activate:(BOOL)activate;

- (void)loop;
- (void)startLoop;
- (void)stopLoop;
- (void)addObjectToScene:(AXSceneObject*)sceneObject;
- (void)removeObjectFromScene:(AXSceneObject*)sceneObject;

// game specific
- (void)generateRocks;

@end
