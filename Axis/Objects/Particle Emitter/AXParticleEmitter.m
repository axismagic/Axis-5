//
//  AXParticleEmitter.m
//  Axis
//
//  Created by Jethro Wilson on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXParticleEmitter.h"
#import "AXParticle.h"

@implementation AXParticleEmitter

@synthesize emit, materialKey, emissionRange, sizeRange, growRange, xVelocityRange, yVelocityRange, lifeRange, decayRange, emitCounter;

- (id)init {
    self = [super init];
    if (self != nil) {
        [self setDefaultSystem];
    }
    return self;
}

- (void)setDefaultSystem {
    self.emissionRange = AXRangeMake(1.0, 2.0);
    self.sizeRange = AXRangeMake(4.0, 8.0);
    self.growRange = AXRangeMake(-0.5, -0.1);
    self.xVelocityRange = AXRangeMake(-8.0, -5.0);
    self.yVelocityRange = AXRangeMake(-3.0, 3.0);
    self.lifeRange = AXRangeMake(0.0, 2.0);
    self.decayRange = AXRangeMake(0.05, 0.2);
    self.emit = NO;
    // emit forever
    emitCounter = -1;
}

- (void)awake {
    if (activeParticles == nil)
        activeParticles = [[NSMutableArray alloc] init];
    
    // pre-allocate max particles
    // ***** Add method for custom max particles
    particlePool = [[NSMutableArray alloc] initWithCapacity:AX_MAX_PARTICLES];
    NSInteger count = 0;
    for (count = 0; count < AX_MAX_PARTICLES; count++) {
        AXParticle *p = [[AXParticle alloc] init];
        [particlePool addObject:p];
        [p release];
    }
    
    // create space for particle mesh and uv
    vertexes = (CGFloat*) malloc(3 * 6 * AX_MAX_PARTICLES * sizeof(CGFloat));
    uvCoordinates = (CGFloat*) malloc(2 * 6 * AX_MAX_PARTICLES * sizeof(CGFloat));
}

- (void)setParticle:(NSString *)atlasKey {
    AXTexturedQuad *quad = [[AXMaterialController sharedMaterialController] quadFromAtlasKey:atlasKey];
    
    self.materialKey = quad.materialKey;
    
    CGFloat u, v;
    NSInteger index;
    minU = minV = 1.0;
    maxU = maxV = 0.0;
    CGFloat *uvs = [quad uvCoordinates];
    for (index = 0; index < quad.vertexCount; index++) {
        u = uvs[index * 2];
        v = uvs[(index * 2) + 1];
        if (u < minU) minU = u;
        if (v < minV) minV = v;
        if (u > maxU) maxU = u;
        if (v > maxV) maxV = v;
    }
}

- (void)endUpdate {
    // build arrays
    [self buildVertexArrays];
    
    // generate new particles, queue them for addition
    [self emitNewParticles];
    
    // remove old particles
    [self clearDeadQueue];
}

/* *R?* - (void)update {
    [super update];
    
    // build arrays
    [self buildVertexArrays];
    
    // generate new particles, queue them for addition
    [self emitNewParticles];
    
    // remove old particles
    [self clearDeadQueue];
}*/

- (BOOL)activeParticles {
    if ([activeParticles count] > 0)
        return YES;
    return NO;
}

- (void)buildVertexArrays {
    vertexIndex = 0;
    for (AXParticle *particle in activeParticles) {
        [particle update];
        
        // check if particle is still alive
        if ((particle.life < 0) || (particle.size < 0.3)) {
            [self removeChildParticle:particle];
            continue;
        }
        
        // quad for each particle, loaded clockwise
        
        // first triangle
        [self addVertex:(particle.position.x - particle.size)
                      y:(particle.position.y + particle.size)
                      u:minU
                      v:minV];
        [self addVertex:(particle.position.x + particle.size)
                      y:(particle.position.y - particle.size)
                      u:maxU
                      v:maxV];
        [self addVertex:(particle.position.x - particle.size)
                      y:(particle.position.y - particle.size)
                      u:minU
                      v:maxV];
        
        // second triangle
        [self addVertex:(particle.position.x - particle.size)
                      y:(particle.position.y + particle.size)
                      u:minU
                      v:minV];
        [self addVertex:(particle.position.x + particle.size)
                      y:(particle.position.y + particle.size)
                      u:maxU
                      v:minV];
        [self addVertex:(particle.position.x + particle.size)
                      y:(particle.position.y - particle.size)
                      u:maxU
                      v:maxV];
    }
}

- (void)render {
    if (!_active)
        return;
    
    // clear matrix
    glPushMatrix();
    glLoadIdentity();
    
    // bind texture
    [[AXMaterialController sharedMaterialController] bindMaterial:materialKey];
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    // send arrays to the renderer
    glVertexPointer(3, GL_FLOAT, 0, vertexes);
    glTexCoordPointer(2, GL_FLOAT, 0, uvCoordinates);
    // draw
    glDrawArrays(GL_TRIANGLES, 0, vertexIndex);
    
    glPopMatrix();
}

- (void)emitNewParticles {
    if (!emit)
        return;
    if (emitCounter > 0)
        emitCounter--;
    if (emitCounter == 0)
        emit = NO;
    
    NSInteger newParticles = (NSInteger)AXRandomFloat(emissionRange);
    
    NSInteger index;
    CGFloat veloX, veloY;
    for (index = 0; index < newParticles; index++) {
        if ([particlePool count] == 0) {
            // run out of particles, cancel method now
            return;
        }
        
        // grab premade partcile, set it up
        AXParticle *p = [particlePool lastObject];
        p.position = _location;
        veloX = AXRandomFloat(xVelocityRange);
        veloY = AXRandomFloat(yVelocityRange);
        p.velocity = AXPointMake(veloX, veloY, 0.0);
        
        p.life = AXRandomFloat(lifeRange);
        p.size = AXRandomFloat(sizeRange);
        p.grow = AXRandomFloat(growRange);
        p.decay = AXRandomFloat(decayRange);
        
        // add particle
        [activeParticles addObject:p];
        // remove from the pool
        [particlePool removeLastObject];
    }
}

- (void)removeChildParticle:(AXParticle *)particle {
    if (objectsToRemove == nil)
        objectsToRemove = [[NSMutableArray alloc] init];
    [objectsToRemove addObject:particle];
}

- (void)clearDeadQueue {
    // recycle old particles by moving them into the pool
    if ([objectsToRemove count] > 0) {
        [activeParticles removeObjectsInArray:objectsToRemove];
        [particlePool addObjectsFromArray: objectsToRemove];
        [objectsToRemove removeAllObjects];
    }
}

- (void)addVertex:(CGFloat)x y:(CGFloat)y u:(CGFloat)u v:(CGFloat)v {
    NSInteger pos = vertexIndex * 3.0;
    vertexes[pos] = x;
    vertexes[pos + 1] = y;
    vertexes[pos + 2] = _location.z;
    
    // UV array position
    pos = vertexIndex * 2.0;
    uvCoordinates[pos] = u;
    uvCoordinates[pos + 1] = v;
    // increment vertex count
    vertexIndex++;
}

- (void)dealloc {
    [particlePool release];
    [activeParticles release];
    
    free(vertexes);
    free(uvCoordinates);
    
    [super dealloc];
}

@end
