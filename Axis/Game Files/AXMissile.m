//
//  AXMissile.m
//  Axis
//
//  Created by Jethro Wilson on 27/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXMissile.h"

#import "AXRock.h"
#import "AXCollider.h"

#pragma mark Missile mesh

static NSInteger BBMissileVertexStride = 2;
static NSInteger BBMissileColorStride = 4;

static NSInteger BBMissileOutlineVertexesCount = 3;
static CGFloat BBMissileOutlineVertexes[6] = 
{-0.2, 0.0,  0.2,0.0,  0.0, 2.0};

static CGFloat BBMissileColorValues[12] = 
{1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0};

@implementation AXMissile

- (void)awake {
    mesh = [[AXMesh alloc] initWithVertexes:BBMissileOutlineVertexes
                                vertexCount:BBMissileOutlineVertexesCount
                               vertexStride:BBMissileVertexStride
                                renderStyle:GL_TRIANGLES];
    mesh.colors = BBMissileColorValues;
    mesh.colorStride = BBMissileColorStride;
    
    self.collider = [AXCollider collider];
    [self.collider setCheckForCollisions:YES];
}

- (void)checkArenaBounds {
    BOOL outOfArena = NO;
    
    if (translation.x > (240.0 + CGRectGetWidth(self.meshBounds)/2.0))
        outOfArena = YES;
    if (translation.x < (-240.0 - CGRectGetWidth(self.meshBounds)/2.0))
        outOfArena = YES;
    
    if (translation.y > (160.0 + CGRectGetWidth(self.meshBounds)/2.0))
        outOfArena = YES;
    if (translation.y < (-160.0 - CGRectGetWidth(self.meshBounds)/2.0))
        outOfArena = YES;
    
    if (outOfArena) {
        [[AXSceneController sharedSceneController] removeObjectFromScene:self];
    }
}

- (void)didCollideWith:(AXSceneObject*)sceneObject {
    if (![sceneObject isKindOfClass:[AXRock class]])
        return;
    if (![sceneObject.collider doesCollideWithMesh:self])
        return;
    [(AXRock*)sceneObject smash];
    // destroy ship
    [[AXSceneController sharedSceneController] removeObjectFromScene:self];
}

@end
