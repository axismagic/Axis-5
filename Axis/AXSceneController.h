//
//  AXSceneController.h
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AXInputViewController;
@class EAGLView;

@interface AXSceneController : NSObject {
    NSMutableArray *sceneObjects;
    
    AXInputViewController *inputController;
    EAGLView *openGLView;
    
    NSTimer *animationTimer;
    NSTimeInterval animationInterval;
}

@property (retain) AXInputViewController *inputController;
@property (retain) EAGLView *openGLView;

@property NSTimeInterval animationInterval;
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

@end
