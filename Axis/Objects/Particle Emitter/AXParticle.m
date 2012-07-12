//
//  AXParticle.m
//  Axis
//
//  Created by Jethro Wilson on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXParticle.h"

@implementation AXParticle

@synthesize position, velocity, life, size, grow, decay;

- (void)update {
    position.x += velocity.x;
    position.y += velocity.y;
    position.z += velocity.z;
    
    life -= decay;
    size += grow;
    if (size < 0.0)
        size = 0.0;
}

@end
