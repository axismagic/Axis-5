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
#import "AXSceneController.h"
#import "AXConfiguration.h"
#import "AXMaterialController.h"
#import "AXTexturedQuad.h"
#import "AXAnimatedQuad.h"

@class AXCollider;

@protocol AXSpriteProtocol <NSObject>
@optional

/*
 Scene ownership protocol allows a scene to take control over all objects, even children of objects, and submit them to high level things such as the Collision Controller
*/

// evaluates object, runs checks for collider submission, etc.
//- (void)submitForEvaluation:(AXSprite*)object;

@end

@interface AXSprite : AXObject {
    // delegate
    AXScene <AXSpriteProtocol> *_spriteDelegate;
    
    // mesh
    AXMesh *_mesh;
    CGRect _meshBounds;
    
    // collider
    AXCollider *_collider;
}

@property (nonatomic, retain) AXScene <AXSpriteProtocol> *spriteDelegate;

@property (nonatomic, retain) AXMesh *mesh;
@property (nonatomic, assign) CGRect meshBounds;

@property (nonatomic, retain) AXCollider *collider;

@end
