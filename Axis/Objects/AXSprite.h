//
//  AXSceneObject.h
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXObject.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>

#import "AXPoint.h"
#import "AXMesh.h"
#import "AXInputViewController.h"
#import "AXDirector.h"
#import "AXConfiguration.h"
#import "AXMaterialController.h"
#import "AXTexturedQuad.h"
#import "AXAnimatedQuad.h"

@class AXCollider;

@interface AXSprite : AXObject {
    
    // mesh
    AXMesh *_mesh;
    CGRect _meshBounds;
    
    // collider
    BOOL _collisionDetection;
    AXCollider *_collider;
}

@property (nonatomic, retain) AXMesh *mesh;
@property (nonatomic, assign) CGRect meshBounds;

@property (nonatomic, assign) BOOL collisionDetection;
@property (nonatomic, retain) AXCollider *collider;

- (id)initWithSpriteImage:(NSString*)spriteName;

- (void)didCollideWith:(AXSprite*)object;

@end
