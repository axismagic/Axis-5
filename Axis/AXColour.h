//
//  AXColour.h
//  Axis
//
//  Created by Jethro Wilson on 24/05/2013.
//
//

#pragma mark AXColour

// stores rgba

typedef struct {
    CGFloat r, g, b, a;
} AXColour;

typedef AXColour *AXColourPtr;

static inline AXColour AXColourMake(CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    return (AXColour) {r, g, b, a};
}