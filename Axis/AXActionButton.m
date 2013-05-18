//
//  AXActionButton.m
//  Axis
//
//  Created by Jethro Wilson on 18/05/2013.
//
//

#import "AXActionButton.h"

@implementation AXActionButton

@synthesize actionOn = _actionOn;

- (void)activate {
    self.actionOn = NO;
    [[[AXDirector sharedDirector] inputController] registerObjectForTouches:self swallowsTouchesType:AXInputObjectSwallows];
    
    [super activate];
}

- (BOOL)axTouchIsMine:(UITouch *)touch {
    // get touch location
    CGPoint touchPoint = [touch locationInView:[touch view]];
    AXPoint touchPointLocation = [[[AXDirector sharedDirector] inputController] convertTouchPointToAxisPoint:touchPoint];
    
    CGFloat distance = AXPointDistance(touchPointLocation, self.location);
    if (distance < self.meshBounds.size.height/2) {
        NSLog(@"Action Button Claimed");
        return YES;
    } else {
        return NO;
    }
}

- (void)axTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.actionOn = YES;
}

- (void)axTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.actionOn = NO;
}

- (void)axTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.actionOn = NO;
}

@end
