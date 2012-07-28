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
#import "AXAnimatedQuad.h"

#import "AXParticleEmitter.h"

#pragma mark Missile mesh

/*
 static NSInteger BBMissileVertexStride = 2;
 static NSInteger BBMissileColorStride = 4;

 static NSInteger BBMissileOutlineVertexesCount = 3;
 static CGFloat BBMissileOutlineVertexes[6] = 
{-0.2, 0.0,  0.2,0.0,  0.0, 2.0};

 static CGFloat BBMissileColorValues[12] = 
{1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0};
*/

@implementation AXMissile

- (void)awake {
    /*
     mesh = [[AXMesh alloc] initWithVertexes:BBMissileOutlineVertexes
                                vertexCount:BBMissileOutlineVertexesCount
                               vertexStride:BBMissileVertexStride
                                renderStyle:GL_TRIANGLES];
    mesh.colors = BBMissileColorValues;
    mesh.colorStride = BBMissileColorStride;
    
    self.collider = [AXCollider collider];
    [self.collider setCheckForCollisions:YES];
    */
    
    self.mesh = [[AXMaterialController sharedMaterialController] animationFromAtlasKeys:[NSArray arrayWithObjects:@"missile1", @"missile2", @"missile3", nil]];
    self.scale = AXPointMake(12, 31, 1.0);
    
    [(AXAnimatedQuad*)_mesh setLoops:YES];
    _mesh.radius = 0.35;
    self.collider = [AXCollider collider];
    [self.collider setCheckForCollisions:YES];
    
    // particle emitter
    particleEmitter = [[AXParticleEmitter alloc] init];
    particleEmitter.emissionRange = AXRangeMake(3.0, 0.0);
    particleEmitter.sizeRange = AXRangeMake(8.0, 1.0);
    particleEmitter.growRange = AXRangeMake(-0.8, 0.5);
    
    particleEmitter.xVelocityRange = AXRangeMake(-0.5, 1.0);
    particleEmitter.yVelocityRange = AXRangeMake(-0.5, 1.0);
    
    particleEmitter.lifeRange = AXRangeMake(0.0, 2.5);
    particleEmitter.decayRange = AXRangeMake(0.03, 0.05);
    
    [particleEmitter setParticle:@"redBlur"];
    particleEmitter.emit = NO;
    
    destroyed = NO;
    
    emitterOffset = AXPointMake(0.0, -2.0, 0.0);
}

- (void)update {
    if (destroyed) {
        if ((particleEmitter.emitCounter <= 0) && (![particleEmitter activeParticles])) {
            [[AXSceneController sharedSceneController] removeObjectFromScene:self];
        }
        return;
    }
    particleEmitter.location = AXPointMatrixMultiply(emitterOffset, _matrix);
    
    [super update];
    
    if ([_mesh isKindOfClass:[AXAnimatedQuad class]])
        [(AXAnimatedQuad*)_mesh updateAnimation];
    
    // if not emitting and are active, start emitting
    if (!particleEmitter.emit && _active && !destroyed) {
        [[AXSceneController sharedSceneController] addObjectToScene:particleEmitter];
        particleEmitter.emit = YES;
    }
}

- (void)checkArenaBounds {
    BOOL outOfArena = NO;
    
    if (_location.x > (240.0 + CGRectGetWidth(self.meshBounds)/2.0))
        outOfArena = YES;
    if (_location.x < (-240.0 - CGRectGetWidth(self.meshBounds)/2.0))
        outOfArena = YES;
    
    if (_location.y > (160.0 + CGRectGetWidth(self.meshBounds)/2.0))
        outOfArena = YES;
    if (_location.y < (-160.0 - CGRectGetWidth(self.meshBounds)/2.0))
        outOfArena = YES;
    
    if (outOfArena) {
        [[AXSceneController sharedSceneController] removeObjectFromScene:self];
    }
}

- (void)didCollideWith:(AXSprite*)sceneObject {
    if (![sceneObject isKindOfClass:[AXRock class]])
        return;
    if (![sceneObject.collider doesCollideWithMesh:self])
        return;
    
    // smash the rock
    [(AXRock*)sceneObject smash];
    // remove self
    [[AXSceneController sharedSceneController] removeObjectFromScene:self];
    
    // destroy ourselves
    [self handleCollision];
}

- (void)handleCollision {
    self.active = NO;
    particleEmitter.emit = NO;
    destroyed = YES;
    self.collider = nil;
}

- (void)dealloc {
    if (particleEmitter != nil)
        [[AXSceneController sharedSceneController] removeObjectFromScene:particleEmitter];
    
    [particleEmitter release];
    [super dealloc];
}

@end
