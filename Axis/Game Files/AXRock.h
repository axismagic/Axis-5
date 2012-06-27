//
//  AXRock.h
//  Axis
//
//  Created by Jethro Wilson on 21/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXMobileObject.h"

@interface AXRock : AXMobileObject {
    CGFloat *verts;
    CGFloat *colors;
    NSInteger smashCount;
}

@property (assign) NSInteger smashCount;

+ (AXRock*)randomRock;
+ (AXRock*)randomRockWithScale:(NSRange)scaleRange;
- (void)smash;

@end
