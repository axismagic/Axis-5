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

@protocol AXObjectProtocol <NSObject>
@optional

- (void)submitForEvaluation:(AXObject*)object;

@end

@interface AXObject : NSObject {
    // delegate
    AXScene <AXObjectProtocol> *_objectDelegate;
    
    // locations
    AXPoint _vectorFromParent;
    
    // location, rotation and scale
    AXPoint _location;
    AXPoint _rotation;
    AXPoint _scale;
    
    CGFloat *_matrix;
    
    // Parent/Child variables
    NSMutableArray *children;
    BOOL _hasChildren;
    BOOL _isChild;
    
    // updates? ***** check
    BOOL _active;
}

@property (nonatomic, retain) AXScene <AXObjectProtocol> *objectDelegate;

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
- (void)removeChild:(NSString*)childKey;

@end