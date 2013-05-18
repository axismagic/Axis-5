//
//  AXDynamicJoyStick.h
//  Axis
//
//  Created by Jethro Wilson on 18/05/2013.
//
//

#import "AXObject.h"

@class AXSprite;

@interface AXDynamicJoyStick : AXObject <AXInputProtocol> {
    AXSprite *_thumbPad;
    AXSprite *_stickBase;
    
    CGPoint _movementPower;
}

@property (nonatomic, assign) CGPoint movementPower;

@property (nonatomic, retain) AXSprite *thumbPad;
@property (nonatomic, retain) AXSprite *stickBase;

@end
