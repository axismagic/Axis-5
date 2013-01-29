//
//  AXHero.m
//  Axis
//
//  Created by Jethro Wilson on 31/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXHero.h"
#import "AXCollider.h"

@implementation AXHero

- (void)awake {
    self.mesh = [[AXMaterialController sharedMaterialController] quadFromAtlasKey:@"HeroSide"];
    
    self.collider = [AXCollider collider];
    [self.collider setCheckForCollisions:YES];
    
    [super awake];
}

- (void)setFront {
    self.mesh = [[AXMaterialController sharedMaterialController] quadFromAtlasKey:@"HeroFront"];
}

@end
