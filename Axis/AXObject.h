//
//  AXObject.h
//  Axis
//
//  Created by Jethro Wilson on 27/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>

#import "AXPoint.h"
#import "AXAction.h"
#import "AXActionSet.h"
#import "AXActivity.h"
#import "AXActivitySet.h"

#import "AXInputProtocol.h"

@class AXScene;
@class AXObject;

enum ConflictionModes {
    kActionConflictionAcceptAll = 0, // will accept and run all actions
    kActionConflictionRemoveExisting = 1, // will remove old conflicting action
    kActionConflictionRemoveNew = 2 // will not add new conflicting action
};

@protocol AXSceneObjectProtocol <NSObject>
/* This protocol is used to send messages directly to the scene. */

// add objects directly to scene
- (void)addObjectToScene:(AXObject*)object;
- (void)removeObjectFromScene:(AXObject*)object;

// add colliders directly to scene for object
- (void)addObjectCollider:(AXObject*)object;
- (void)removeObjectCollider:(AXObject*)object;

@end

@protocol AXParentObjectProtocol <NSObject>
/* This protocol is used to send messgaes directly to the parent. */

// add object to parent
- (void)addObjectToParent:(AXObject*)object;
- (void)removeObjectFromParent:(AXObject*)object;

@end

@interface AXObject : NSObject <AXParentObjectProtocol, AXActivityProtocol, AXInputProtocol> {
    // delegate
    AXScene <AXSceneObjectProtocol> *_sceneDelegate;
    AXObject <AXParentObjectProtocol> *_parentDelegate;
    
    // locations
    AXPoint _vectorFromParent;
    
    // location, rotation and scale
    AXPoint _location;
    AXPoint _rotation;
    AXPoint _scale;
    
    CGFloat *_matrix;
    
    // Parent/Child variables
    NSMutableArray *children;
    NSMutableArray *childrenToAdd;
    NSMutableArray *childrenToRemove;
    BOOL _hasChildren;
    BOOL _isChild;
    
    BOOL _active;
    BOOL _updates;
    BOOL _renders;
    
    // Actions Queue Mode
    NSInteger _actionQueueMode;
    // Actions & Activities
    NSMutableArray *activities;
    NSMutableArray *activitiesToRemove;
    NSMutableArray *actions;
    NSMutableArray *actionsToRemove;
}

@property (nonatomic, retain) AXScene <AXSceneObjectProtocol> *sceneDelegate;
@property (nonatomic, retain) AXObject <AXParentObjectProtocol> *parentDelegate;

@property (nonatomic, assign) AXPoint vectorFromParent;
@property (nonatomic, assign) AXPoint location;
@property (nonatomic, assign) AXPoint rotation;
@property (nonatomic, assign) AXPoint scale;

@property (nonatomic, assign) CGFloat *matrix;

@property (nonatomic, assign) BOOL hasChildren;
@property (nonatomic, assign) BOOL isChild;

@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) BOOL updates;
@property (nonatomic, assign) BOOL renders;

@property (nonatomic, assign) NSInteger actionQueuemode;

// activate & reset
- (void)awake;

- (void)activate;
- (void)deactivate;

// update phases and render
- (void)update;
- (void)preUpdate;
- (void)midPhaseUpdate;
- (void)secondMidPhaseUpdate;
- (void)postUpdate;
- (void)render;

// add and remove children
- (void)addChild:(AXObject*)child;
- (void)removeChild:(AXObject*)child;

// actions
- (void)updateActions;
- (void)performAction:(AXAction*)action;
- (AXActivity*)interpretAction:(AXAction*)action;
// ****? - (void)interpretActionAndMoveToActivities:(AXAction *)action;
// action control
/*- (void)playNow:(AXAction*)action;
- (void)cancelCurrentAction;
- (void)cancelAllActions;*/

@end