//
//  AXCollider.h
//  Axis
//
//  Created by Jethro Wilson on 27/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXSceneObject.h"

@protocol AXCollisionHandlerProtocol

- (void)didCollideWith:(AXSceneObject*)sceneObject;

@end

@interface AXCollider : AXSceneObject {
    AXPoint transformedCentroid;
    BOOL checkForCollisions;
    CGFloat maxRadius;
}

@property (assign) BOOL checkForCollisions;
@property (assign) CGFloat maxRadius;

+ (AXCollider*)collider;
- (void)updateCollider:(AXSceneObject*)sceneObject;
- (BOOL)doesCollideWithCollider:(AXCollider*)aCollider;
- (BOOL)doesCollideWithMesh:(AXSceneObject*)sceneObject;

- (void)awake;
- (void)render;
- (void)dealloc;

@end