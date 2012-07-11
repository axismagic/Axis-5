//
//  AXAnimation.m
//  Axis
//
//  Created by Jethro Wilson on 03/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXAnimation.h"

@implementation AXAnimation

- (id)initWithAtlasKeys:(NSArray *)keys loops:(BOOL)loops speed:(NSInteger)speed {
    self = [super init];
    if (self != nil) {
        self.mesh = [[AXMaterialController sharedMaterialController] animationFromAtlasKeys:keys];
        [(AXAnimatedQuad*)mesh setSpeed:speed];
        [(AXAnimatedQuad*)mesh setLoops:loops];
    }
    
    return self;
}

- (void)awake {
    
}

- (void)update {
    [super update];
    [(AXAnimatedQuad*)mesh updateAnimation];
    if ([(AXAnimatedQuad*)mesh didFinish])
        [[AXSceneController sharedSceneController] removeObjectFromScene:self];
}

@end
