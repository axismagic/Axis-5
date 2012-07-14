//
//  AXInterfaceController.h
//  Axis
//
//  Created by Jethro Wilson on 14/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXInterfaceController : NSObject {
    NSMutableArray *interfaceObjects;
}

- (void)loadInterface;
- (void)updateInterface;
- (void)renderInterface;

@end