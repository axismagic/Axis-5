//
//  AXInputHandler.m
//  Axis
//
//  Created by Jethro Wilson on 17/05/2013.
//
//

#import "AXInputHandler.h"

#import "AXObject.h"
#import "AXConfiguration.h"

@implementation AXInputHandler

@synthesize swallowType = _swallowType;
@synthesize claimedTouches = _claimedTouches;
@synthesize endedTouches = _endedTouches;
@synthesize object = _object;

- (id)initWithRegisteredObject:(AXObject*)theObject swallowType:(AXInputObjectSwallowType)doesSwallow {
    self = [super init];
    
    if (self != nil) {
        // object
        _object = theObject;
        // touches
        _swallowType = doesSwallow;
        _claimedTouches = [[NSMutableSet alloc] init];
        _endedTouches = [[NSMutableSet alloc] init];
    }
    
    return self;
}

- (void)dispatchClaimedTouchesWithSelector:(SEL)selector withEvent:(UIEvent*)event {
    if ([self.claimedTouches count] == 0) {
        return;
    }
    
    // dispatch touches
    if ([self.object respondsToSelector:selector])
        [self.object performSelector:selector withObject:self.claimedTouches withObject:event];
    else
        if (AX_CONSOLE_SILIENCE_TOUCH_WARNINGS == 0)
            NSLog(@"WARN: Object did not respond to touch selector due to one of the axTouch methods not being implemented. It did not receive the update.");
    
    // remove ended touches
    if ([self.endedTouches count] > 0) {
        // remove ended touches from main set
        [self.claimedTouches minusSet:self.endedTouches];
        [self.endedTouches removeAllObjects];
    }
}

- (void)dispatchTouches:(NSSet*)touches withEvent:(UIEvent*)event selector:(SEL)selector {
    if ([self.object respondsToSelector:selector])
        [self.object performSelector:selector withObject:touches withObject:event];
    else
        if (AX_CONSOLE_SILIENCE_TOUCH_WARNINGS == 0)
            NSLog(@"WARN: Object did not respond to touch selector due to one of the axTouch methods not being implemented. It did not receive the update.");
}

@end
