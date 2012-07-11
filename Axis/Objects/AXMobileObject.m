//
//  AXMobileObject.m
//  Axis
//
//  Created by Jethro Wilson on 21/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXMobileObject.h"

@implementation AXMobileObject

@synthesize speed, rotationalSpeed;

- (void)update {
    CGFloat deltaTime = [[AXSceneController sharedSceneController] deltaTime];
    /* Investigate
     translation.x += speed.x * deltaTime * 60;
    */
    
    int multiplier;
    if (AX_USE_POINT_PER_SECOND)
        multiplier = 1;
    else
        multiplier = 60;
    
    translation.x += speed.x * deltaTime * multiplier;
    translation.y += speed.y * deltaTime * multiplier;
    translation.z += speed.z * deltaTime * multiplier;
    
    rotation.x += rotationalSpeed.x * deltaTime * multiplier;
    rotation.y += rotationalSpeed.y * deltaTime * multiplier;
    rotation.z += rotationalSpeed.z * deltaTime * multiplier;
    
    [self checkArenaBounds];
    [super update];
}

- (void)checkArenaBounds {
    if (translation.x > (240.0 + CGRectGetWidth(self.meshBounds)/2.0)) translation.x -= 480.0 + CGRectGetWidth(self.meshBounds);
    if (translation.x < (-240.0 - CGRectGetWidth(self.meshBounds)/2.0)) translation.x += 480.0 + CGRectGetWidth(self.meshBounds);
    
    if (translation.y > (160.0 + CGRectGetWidth(self.meshBounds)/2.0)) translation.y -= 320.0 + CGRectGetWidth(self.meshBounds);
    if (translation.y < (-160.0 - CGRectGetWidth(self.meshBounds)/2.0)) translation.y += 320.0 + CGRectGetWidth(self.meshBounds);
}

@end
