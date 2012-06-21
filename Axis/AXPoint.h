//
//  AXPoint.h
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// 3D Point

typedef struct {
    CGFloat x, y, z;
} AXPoint;

typedef AXPoint *AXPointPtr;

static inline AXPoint AXPointMake(CGFloat x, CGFloat y, CGFloat z) {
    return (AXPoint) {x, y, z};
}
