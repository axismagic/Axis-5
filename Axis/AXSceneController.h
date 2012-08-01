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
@class AXSprite;
@class AXScene;

@interface AXSceneController : NSObject {
    
    // all scenes
    NSMutableDictionary *scenes;
    // scene keys for scenes to update
    NSMutableArray *updatingSceneKeys;
    // key for active, rendering scene
    NSString *_activeSceneKey;
    
    // OpenGL View
    EAGLView *_openGLView;
    // Input Controller
    AXInputViewController *_inputController;
    /*
     To avoid all sceneObjects from all scenes being checked when only one is active, collisions should be moved to individual scenes.
     Should same happen for inputController? No, active BOOL stops scenes from doing anything with touches. Should.
    */
    AXCollisionController *collisionController;
    
    CGSize _viewSize;
    
    // Loop tracking
    CADisplayLink *displayLink;
    
    NSTimer *animationTimer;
    NSTimeInterval animationInterval;
    
    NSDate *_startDate;
    
    NSTimeInterval _deltaTime;
    NSTimeInterval lastFrameStartTime;
    NSTimeInterval thisFrameStartTime;
    
    NSMutableDictionary *scenesToAdd;
    NSMutableArray *scenesToRemove;
}

@property (retain) EAGLView *openGLView;
@property (retain) AXInputViewController *inputController;

@property (retain) NSString *activeSceneKey;

@property (assign) CGSize viewSize;

@property (retain) NSDate *startDate;
@property NSTimeInterval deltaTime;
@property (nonatomic, assign) NSTimeInterval animationInterval;
@property (nonatomic, assign) NSTimer *animationTimer;

+ (AXSceneController*)sharedSceneController;
- (void)dealloc;
// animation control
- (void)setAnimationInterval:(NSTimeInterval)interval;
- (void)setAnimationTimer:(NSTimer*)newTimer;
- (void)startAnimation;
- (void)stopAnimation;
// loop control
- (void)loop;
- (void)startLoop;
- (void)stopLoop;


// add and remove scenes
- (void)loadScene;
- (void)loadScene:(AXScene*)scene forKey:(NSString*)sceneKey activate:(BOOL)activate;
- (void)removeScene:(NSString*)sceneKey;
// scene control
- (void)activateScene:(NSString*)sceneKey;
- (void)deactivateScene:(NSString*)sceneKey;
- (void)deactivateScenesExcept:(NSString*)sceneKey;
- (void)updateSceneBehindTheScenes:(NSString*)sceneKey;

@end
