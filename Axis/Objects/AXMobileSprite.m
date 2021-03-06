//
//  AXMobileObject.m
//  Axis
//
//  Created by Jethro Wilson on 21/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXMobileSprite.h"

@implementation AXMobileSprite

@synthesize speed, rotationalSpeed;

- (void)beginUpdate {
    CGFloat deltaTime = [[AXDirector sharedDirector] deltaTime];
    
    int multiplier;
    if (AX_ENABLE_POINT_PER_SECOND)
        multiplier = 1;
    else
        multiplier = 60;
    
    _location.x += speed.x * deltaTime * multiplier;
    _location.y += speed.y * deltaTime * multiplier;
    _location.z += speed.z * deltaTime * multiplier;
    
    _rotation.x += rotationalSpeed.x * deltaTime * multiplier;
    _rotation.y += rotationalSpeed.y * deltaTime * multiplier;
    _rotation.z += rotationalSpeed.z * deltaTime * multiplier;
}

/* *R?* - (void)update {
    if (!_active)
        return;
    
    CGFloat deltaTime = [[AXDirector sharedDirector] deltaTime];
    
    int multiplier;
    if (AX_ENABLE_POINT_PER_SECOND)
        multiplier = 1;
    else
        multiplier = 60;
    
    _location.x += speed.x * deltaTime * multiplier;
    _location.y += speed.y * deltaTime * multiplier;
    _location.z += speed.z * deltaTime * multiplier;
    
    _rotation.x += rotationalSpeed.x * deltaTime * multiplier;
    _rotation.y += rotationalSpeed.y * deltaTime * multiplier;
    _rotation.z += rotationalSpeed.z * deltaTime * multiplier;
    
    //[self checkArenaBounds];
    
    // [super update];
}*/

- (void)checkArenaBounds {
    // ***** Bound checking currently broken
    if (_location.x > (240.0 + CGRectGetWidth(self.meshBounds)/2.0))
        _location.x -= 480.0 + CGRectGetWidth(self.meshBounds);
    if (_location.x < (-240.0 - CGRectGetWidth(self.meshBounds)/2.0))
        _location.x += 480.0 + CGRectGetWidth(self.meshBounds);
    
    if (_location.y > (160.0 + CGRectGetHeight(self.meshBounds)/2.0))
        _location.y -= 320.0 + CGRectGetHeight(self.meshBounds);
    if (_location.y < (-160.0 - CGRectGetHeight(self.meshBounds)/2.0))
        _location.y += 320.0 + CGRectGetHeight(self.meshBounds);
}

@end
