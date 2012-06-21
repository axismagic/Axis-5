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

@interface AXSceneObject : NSObject {
    AXPoint translation;
    AXPoint rotation;
    AXPoint scale;
    
    AXMesh *mesh;
    
    CGRect meshBounds;
    
    BOOL active;
}

@property (retain) AXMesh *mesh;

@property (assign) CGRect meshBounds;

@property (assign) AXPoint translation;
@property (assign) AXPoint rotation;
@property (assign) AXPoint scale;

@property (assign) BOOL active;

- (id)init;
- (void)dealloc;
- (void)awake;
- (void)render;
- (void)update;

@end
