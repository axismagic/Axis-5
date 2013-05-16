//
//  AXAnimatedQuad.m
//  Axis
//
//  Created by Jethro Wilson on 03/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXAnimatedQuad.h"
#import "AXDirector.h"

@implementation AXAnimatedQuad

@synthesize speed, loops, didFinish;

- (id)init {
    self = [super init];
    if (self != nil) {
        self.speed = 12; // 12 fps
        self.loops= NO;
        self.didFinish = NO;
        elapsedTime = 0.0;
    }
    
    return self;
}

- (void)dealloc {
    uvCoordinates = 0;
    [super dealloc];
}

- (void)addFrame:(AXTexturedQuad *)aQuad {
    if (frameQuads == nil)
        frameQuads = [[NSMutableArray alloc] init];
    [frameQuads addObject:aQuad];
}

- (void)setFrame:(AXTexturedQuad *)quad {
    self.uvCoordinates = quad.uvCoordinates;
    self.materialKey = quad.materialKey;
}

- (void)updateAnimation {
    elapsedTime += [AXDirector sharedDirector].deltaTime;
    NSInteger frame = (int)(elapsedTime/(1.0/speed));
    if (loops)
        frame = frame % [frameQuads count];
    
    if (frame >= [frameQuads count]) {
        didFinish = YES;
        return;
    }
    
    [self setFrame:[frameQuads objectAtIndex:frame]];
}

@end
