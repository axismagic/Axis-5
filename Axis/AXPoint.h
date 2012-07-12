//
//  AXPoint.h
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#pragma mark AXPoint

// 3D Point

typedef struct {
    CGFloat x, y, z;
} AXPoint;

typedef AXPoint *AXPointPtr;

static inline AXPoint AXPointMake(CGFloat x, CGFloat y, CGFloat z) {
    return (AXPoint) {x, y, z};
}

static inline float AXPointDistance(AXPoint p1, AXPoint p2) {
    return sqrt(((p1.x - p2.x) * (p1.x - p2.x)) + 
                ((p1.y - p2.y) * (p1.y - p2.y)) + 
                ((p1.z - p2.z) * (p1.z - p2.z)));
}

static inline AXPoint AXPointMatrixMultiply(AXPoint p, CGFloat *m) {
    CGFloat x = (p.x*m[0]) + (p.x*m[4]) + (p.x*m[8]) + m[12];
    CGFloat y = (p.x*m[1]) + (p.x*m[5]) + (p.x*m[9]) + m[13];
    CGFloat z = (p.x*m[2]) + (p.x*m[6]) + (p.x*m[10]) + m[14];
    
    return (AXPoint) {x, y, z};
}

#pragma mark AXRange

typedef struct {
    CGFloat start, length;
} AXRange;

static inline AXRange AXRangeMake(CGFloat start, CGFloat len) {
    return (AXRange) {start, len};
}

static inline NSString *NSStringFromAXRange(AXRange p) {
    return  [NSString stringWithFormat:@"{%3.2f, %3.2f}", p.start, p.length];
}

static inline CGFloat AXRandomFloat(AXRange range) {
    // retrn a random float in the range
    CGFloat randPercent = ((CGFloat)(random() % 1001))/1000.0;
    CGFloat offset = randPercent * range.length;
    return  offset + range.start;
}