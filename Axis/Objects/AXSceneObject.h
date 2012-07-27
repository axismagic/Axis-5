//
//  AXSceneObject.h
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>

#import "AXPoint.h"
#import "AXMesh.h"
#import "AXInputViewController.h"
#import "AXSceneController.h"
#import "AXConfiguration.h"
#import "AXMaterialController.h"
#import "AXTexturedQuad.h"
#import "AXAnimatedQuad.h"

@class AXCollider;

@protocol sceneObjectOwnership <NSObject>
@optional

/*
 Scene ownership protocol allows a scene to take control over all objects, even children of objects, and submit them to high level things such as the Collision Controller
*/

// evaluates object, runs checks for collider submission, etc.
- (void)submitForEvaluation:(AXSceneObject*)object;

@end

@interface AXSceneObject : NSObject {
    // new points
    AXPoint worldPosition;
    AXPoint vectorFromParent;
    
    AXPoint translation;
    AXPoint rotation;
    AXPoint scale;
    
    AXMesh *mesh;
    
    CGFloat *matrix;
    
    CGRect meshBounds;
    
    AXCollider *collider;
    
    NSMutableArray *children;
    BOOL hasChildren;
    BOOL isChild;
    
    BOOL active;
    
    // Delegate used to send messages to the scene from the object
    AXScene <sceneObjectOwnership> *_delegate;
}

@property (retain) AXMesh *mesh;
@property (assign) CGFloat *matrix;
@property (retain) AXCollider *collider;

@property (assign) CGRect meshBounds;

@property (assign) AXPoint worldPosition;
@property (assign) AXPoint vectorFromParent;

@property (assign) AXPoint translation;
@property (assign) AXPoint rotation;
@property (assign) AXPoint scale;

@property (assign) BOOL hasChildren;
@property (assign) BOOL isChild;

@property (assign) BOOL active;

@property (nonatomic, retain) AXScene <sceneObjectOwnership> *delegate;

- (id)init;
- (void)dealloc;
- (void)awake;
- (void)render;

- (void)update;
- (void)updateBeginningPhase;
- (void)updateMiddlePhase;
- (void)updateEndPhase;

- (void)addChild:(AXSceneObject*)child;

- (void)finalAwake;

@end
