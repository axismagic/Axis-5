//
//  AXCollider.h
//  Axis
//
//  Created by Jethro Wilson on 27/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXSprite.h"

@protocol AXCollisionHandlerProtocol

- (void)didCollideWith:(AXSprite*)sceneObject;

@end

@interface AXCollider : AXSprite {
    AXPoint transformedCentroid;
    BOOL checkForCollisions;
    CGFloat maxRadius;
}

@property (assign) BOOL checkForCollisions;
@property (assign) CGFloat maxRadius;

+ (AXCollider*)collider;
- (void)updateCollider:(AXSprite*)sceneObject;
- (BOOL)doesCollideWithCollider:(AXCollider*)aCollider;
- (BOOL)doesCollideWithMesh:(AXSprite*)sceneObject;

- (void)awake;
- (void)render;
- (void)dealloc;

@end