//
//  AXTouch.m
//  Axis
//
//  Created by Jethro Wilson on 16/05/2013.
//
//

#import "AXTouch.h"

@implementation AXTouch

@synthesize phase = _phase;
@synthesize currentPoint = _currentPoint, previousPoint = _previousPoint;
@synthesize tapCount = _tapCount;
@synthesize timeStamp = _timeStamp;

+ (AXTouch*)touch {
    return [[AXTouch alloc] init];
}

@end
