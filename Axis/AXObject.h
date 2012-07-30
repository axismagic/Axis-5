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

@class AXScene;
@class AXObject;

@protocol AXSceneObjectProtocol <NSObject>
/* This protocol is used to send messages directly to the scene. */

- (void)addObjectCollider:(AXObject*)object;
- (void)removeObjectCollider:(AXObject*)object;

- (void)addObjectToScene:(AXObject*)object;
- (void)removeObjectFromScene:(AXObject*)object;

@end

@protocol AXParentObjectProtocol <NSObject>
/* This protocol is used to send messgaes directly to the parent. */

- (void)addObjectToParent:(AXObject*)object;
- (void)removeObjectFromParent:(AXObject*)object;

@end

@interface AXObject : NSObject <AXParentObjectProtocol> {
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
    
    // updates? ***** check
    BOOL _active;
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

// activate & reset
- (void)awake;

// update phases and render
- (void)update;
- (void)preUpdate;
- (void)midPhaseUpdate;
- (void)postUpdate;
- (void)render;

// add and remove children
- (void)addChild:(AXObject*)child;
- (void)removeChild:(AXObject*)object;

@end