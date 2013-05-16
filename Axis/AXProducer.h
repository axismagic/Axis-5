//
//  AXProducer.h
//  Axis
//
//  Created by Jethro Wilson on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXProducer : NSObject {
    // global access
}

+ (AXProducer*)sharedProducer;
- (void)setupEngine;

@end
