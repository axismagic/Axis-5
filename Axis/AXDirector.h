//
//  AXDirector.h
//  Axis
//
//  Created by Jethro Wilson on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXDirector : NSObject {
    // global access
}

+ (AXDirector*)sharedDirector;
- (void)setupEngine;

@end
