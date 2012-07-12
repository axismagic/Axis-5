//
//  AXParticle.h
//  Axis
//
//  Created by Jethro Wilson on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXPoint.h"

@interface AXParticle : NSObject {
    AXPoint position;
    AXPoint velocity;
    CGFloat life;
    CGFloat decay;
    CGFloat size;
    CGFloat grow;
}

@property (assign) AXPoint position;
@property (assign) AXPoint velocity;

@property (assign) CGFloat life;
@property (assign) CGFloat size;
@property (assign) CGFloat grow;
@property (assign) CGFloat decay;

- (void)update;

@end
