//
//  AXMissile.h
//  Axis
//
//  Created by Jethro Wilson on 27/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXMobileObject.h"

@class AXParticleEmitter;

@interface AXMissile : AXMobileObject {
    AXParticleEmitter *particleEmitter;
    AXPoint emitterOffset;
    BOOL destroyed;
}

- (void)handleCollision;

@end
