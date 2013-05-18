//
//  AXInputProtocol.h
//  Axis
//
//  Created by Jethro Wilson on 17/05/2013.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    AXInputObjectSwallows,
    AXInputObjectWantsRemaining,
    AXInputObjectWantsAll,
} AXInputObjectSwallowType;

@protocol AXInputProtocol <NSObject>

@optional
- (BOOL)axTouchIsMine:(UITouch*)touch;
- (void)axTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)axTouchesMoved:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)axTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)axTouchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event;

@end