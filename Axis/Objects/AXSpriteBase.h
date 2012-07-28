//
//  AXSprite.h
//  Axis
//
//  Created by Jethro Wilson on 28/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXObject.h"

@class AXSpriteBase;
@class AXCollisionController;
@class AXMesh;
@class AXCollider;

@protocol basecollisionControllerOwnership <NSObject>
@optional

- (void)submitToCollisionController:(AXSpriteBase*)object;

@end

@interface AXSpriteBase : AXObject {
    // delegate
    AXCollisionController <basecollisionControllerOwnership> *_spriteDelegate;
    
    // mesh
    AXMesh *_mesh;
    CGRect _meshBounds;
    
    // collider
    AXCollider *_collider;
}

@property (nonatomic, retain) AXCollisionController <basecollisionControllerOwnership> *spriteDelegate;

@property (nonatomic, retain) AXMesh *mesh;
@property (nonatomic, assign) CGRect meshBounds;

@property (nonatomic, retain) AXCollider *collider;

@end
