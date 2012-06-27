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
    translation.x += speed.x;
    translation.y += speed.y;
    translation.z += speed.z;
    
    rotation.x += rotationalSpeed.x;
    rotation.y += rotationalSpeed.y;
    rotation.z += rotationalSpeed.z;
    
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
