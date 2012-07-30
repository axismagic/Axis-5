//
//  AXParticleEmitter.h
//  Axis
//
//  Created by Jethro Wilson on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXSprite.h"
#import "AXPoint.h"

@class AXParticle;

@interface AXParticleEmitter : AXSprite {
    NSMutableArray *activeParticles;
    NSMutableArray *objectsToRemove;
    NSMutableArray *particlePool;
    GLfloat *vertexes;
    GLfloat *uvCoordinates;
    NSString *materialKey;
    NSInteger vertexIndex;
    BOOL emit;
    CGFloat minU;
    CGFloat maxU;
    CGFloat minV;
    CGFloat maxV;
    
    NSInteger emitCounter;
    
    AXRange emissionRange;
    AXRange sizeRange;
    AXRange growRange;
    
    AXRange xVelocityRange;
    AXRange yVelocityRange;
    
    AXRange lifeRange;
    AXRange decayRange;
}

@property (retain) NSString *materialKey;

@property (assign) BOOL emit;
@property (assign) NSInteger emitCounter;

@property (assign) AXRange emissionRange;
@property (assign) AXRange sizeRange;
@property (assign) AXRange growRange;
@property (assign) AXRange xVelocityRange;
@property (assign) AXRange yVelocityRange;

@property (assign) AXRange lifeRange;
@property (assign) AXRange decayRange;

- (BOOL)activeParticles;
- (id)init;
- (void)dealloc;
- (void)addVertex:(CGFloat)x y:(CGFloat)y u:(CGFloat)u v:(CGFloat)v;
- (void)awake;
- (void)buildVertexArrays;
- (void)clearDeadQueue;
- (void)emitNewParticles;
- (void)removeChildParticle:(AXParticle*)particle;
- (void)render;
- (void)setDefaultSystem;
- (void)setParticle:(NSString*)atlasKey;
- (void)update;

@end
