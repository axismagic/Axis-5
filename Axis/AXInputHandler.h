//
//  AXInputHandler.h
//  Axis
//
//  Created by Jethro Wilson on 17/05/2013.
//
//

#import <Foundation/Foundation.h>

#import "AXInputProtocol.h"

@class AXObject;

@interface AXInputHandler : NSObject {
    AXInputObjectSwallowType _swallowType;
    NSMutableSet *_claimedTouches;
    NSMutableSet *_endedTouches;
    AXObject *_object;
}

@property (nonatomic, assign) AXInputObjectSwallowType swallowType;
@property (nonatomic, retain) NSMutableSet *claimedTouches;
@property (nonatomic, retain) NSMutableSet *endedTouches;
@property (nonatomic, retain) AXObject *object;

- (id)initWithRegisteredObject:(AXObject*)theObject swallowType:(AXInputObjectSwallowType)doesSwallow;

- (void)dispatchClaimedTouchesWithSelector:(SEL)selector withEvent:(UIEvent*)event;
- (void)dispatchTouches:(NSSet*)touches withEvent:(UIEvent*)event selector:(SEL)selector;

@end
