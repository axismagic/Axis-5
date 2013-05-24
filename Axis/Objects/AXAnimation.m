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
        [(AXAnimatedQuad*)_mesh setSpeed:speed];
        [(AXAnimatedQuad*)_mesh setLoops:loops];
    }
    
    return self;
}

- (void)awake {
    
}

/* *R?* - (void)update {
    [super update];
    [(AXAnimatedQuad*)_mesh updateAnimation];
    if ([(AXAnimatedQuad*)_mesh didFinish])
        [_parentDelegate removeObjectFromParent:self];
        //[[AXDirector sharedDirector] removeObjectFromScene:self];
}*/

- (void)endUpdate {
    [(AXAnimatedQuad*)_mesh updateAnimation];
    if ([(AXAnimatedQuad*)_mesh didFinish])
        [_parentDelegate removeObjectFromParent:self];
}

@end
