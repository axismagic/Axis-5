//
//  AXHeroOne.m
//  Axis
//
//  Created by Jethro Wilson on 18/05/2013.
//
//

#import "AXHeroOne.h"

#import "AXInputProtocol.h"

@implementation AXHeroOne

- (void)activate {
    [super activate];
    [[[AXDirector sharedDirector] inputController] registerObjectForTouches:self swallowsTouchesType:AXInputObjectSwallows];
}

#pragma mark - Touches

- (BOOL)axTouchIsMine:(UITouch *)touch {
    // get touch location
    CGPoint touchPoint = [touch locationInView:[touch view]];
    CGSize correctSize = [[AXDirector sharedDirector] viewSize];
    AXPoint correctPoint = AXPointMake(touchPoint.x, correctSize.height - touchPoint.y, 0);
    
    CGFloat distance = AXPointDistance(self.location, correctPoint);
    if (distance < self.meshBounds.size.height/2) {
        NSLog(@"Touch Claimed");
        return YES;
    } else {
        return NO;
    }
}

- (void)axTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Hero1 Touch Began");
}

@end
