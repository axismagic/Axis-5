//
//  AXAnimatedQuad.h
//  Axis
//
//  Created by Jethro Wilson on 03/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXTexturedQuad.h"

@interface AXAnimatedQuad : AXTexturedQuad {
    NSMutableArray *frameQuads;
    CGFloat speed;
    NSTimeInterval elapsedTime;
    BOOL loops;
    BOOL didFinish;
}

@property (assign) CGFloat speed;
@property (assign) BOOL loops;
@property (assign) BOOL didFinish;

- (id)init;
- (void)addFrame:(AXTexturedQuad*)aQuad;
- (void)setFrame:(AXTexturedQuad*)quad;
- (void)updateAnimation;

@end