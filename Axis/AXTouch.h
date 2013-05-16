//
//  AXTouch.h
//  Axis
//
//  Created by Jethro Wilson on 16/05/2013.
//
//

#import <Foundation/Foundation.h>

#import "AXDataConstructs.h"
#import "AXPoint.h"

@interface AXTouch : NSObject {
    AXTouchPhase _phase;
    CGPoint _currentPoint;
    CGPoint _previousPoint;
    int _tapCount;
    CGFloat _timeStamp;
}

@property (nonatomic, assign) AXTouchPhase phase;
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, assign) CGPoint previousPoint;
@property (nonatomic, assign) int tapCount;
@property (nonatomic, assign) CGFloat timeStamp;

+ (AXTouch*)touch;

@end
