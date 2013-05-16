//
//  AXInputProtocol.h
//  Axis
//
//  Created by Jethro Wilson on 17/05/2013.
//
//

#import <Foundation/Foundation.h>

@protocol AXInputProtocol <NSObject>

@optional
- (void)axTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)axTouchesMoved:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)axTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)axTouchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event;

@end