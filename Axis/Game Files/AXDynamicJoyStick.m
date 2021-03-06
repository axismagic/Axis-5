//
//  AXDynamicJoyStick.m
//  Axis
//
//  Created by Jethro Wilson on 18/05/2013.
//
//

#import "AXDynamicJoyStick.h"

#import "AXSprite.h"

@interface AXDynamicJoyStick ()



@end

@implementation AXDynamicJoyStick

@synthesize thumbPad = _thumbPad;
@synthesize stickBase = _stickBase;
@synthesize movementPower = _movementPower;

- (void)activate {
    // setup dynamic joy stick
    _stickBase = [[AXSprite alloc] initWithSpriteImage:@"baseStick"];
    _stickBase.location = AXPointMake(0, 0, 0);
    [self addChild:_stickBase];
    _thumbPad = [[AXSprite alloc] initWithSpriteImage:@"thumbStick"];
    _thumbPad.location = AXPointMake(0, 0, 0);
    [self addChild:_thumbPad];
    // activate stick parts
    
    [self.stickBase activate];
    [self.thumbPad activate];
    
    // register for touches
    [[[AXDirector sharedDirector] inputController] registerObjectForTouches:self swallowsTouchesType:AXInputObjectSwallows];
    
    self.movementPower = CGPointZero;
    
    // continue activation
    [super activate];
}

#pragma mark - Touches

- (BOOL)axTouchIsMine:(UITouch *)touch {
    // get touch location
    CGPoint touchPoint = [touch locationInView:[touch view]];
    AXPoint touchPointLocation = [[[AXDirector sharedDirector] inputController] convertTouchPointToAxisPoint:touchPoint];
    
    CGFloat distance = AXPointDistance(touchPointLocation, self.location);
    if (distance < self.stickBase.meshBounds.size.height/2) {
        NSLog(@"Stick Claimed");
        return YES;
    } else {
        return NO;
    }
}

- (void)axTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        // get touch location
        CGPoint touchPoint = [touch locationInView:[touch view]];
        // convert to Axis Coords
        AXPoint touchPointLocation = [[[AXDirector sharedDirector] inputController] convertTouchPointToAxisPoint:touchPoint];
        
        self.thumbPad.location = AXPointMake(touchPointLocation.x - self.location.x, touchPointLocation.y - self.location.y, 0);
        
        self.movementPower = CGPointMake(self.thumbPad.location.x/100, self.thumbPad.location.y/100);
    }
}

- (void)axTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint touchPoint = [touch locationInView:[touch view]];
        AXPoint touchPointLocation = [[[AXDirector sharedDirector] inputController] convertTouchPointToAxisPoint:touchPoint];
        
        CGFloat distance = AXPointDistance(touchPointLocation, self.location);
        if (distance < self.stickBase.meshBounds.size.height/2) {
            self.thumbPad.location = AXPointMake(touchPointLocation.x - self.location.x, touchPointLocation.y - self.location.y, 0);;
        } else {
            // distance
            CGFloat hyp = AXPointDistance(touchPointLocation, self.location);
            
            CGFloat radius = self.stickBase.meshBounds.size.height/2;
            CGFloat factor = hyp/radius;
            
            CGPoint localTouchPoint = CGPointMake(touchPointLocation.x - self.location.x, touchPointLocation.y - self.location.y);
            
            CGFloat newX;
            CGFloat newY;
            
            if (localTouchPoint.x != 0) {
                newX = localTouchPoint.x / factor;
            } else {
                newX = localTouchPoint.x;
            }
            
            if (localTouchPoint.x != 0) {
                newY = localTouchPoint.y / factor;
            } else {
                newY = localTouchPoint.y;
            }
            
            self.thumbPad.location = AXPointMake(newX, newY, 0);
        }
    }
    
    self.movementPower = CGPointMake(self.thumbPad.location.x/100, self.thumbPad.location.y/100);
}

- (void)axTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.thumbPad.location = AXPointMake(0, 0, 0);
    self.movementPower = CGPointMake(0, 0);
}

- (void)axTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.thumbPad.location = AXPointMake(0, 0, 0);
    self.movementPower = CGPointMake(0, 0);
}

@end
