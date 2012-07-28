//
//  AXMobileObject.h
//  Axis
//
//  Created by Jethro Wilson on 21/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXSprite.h"

@interface AXMobileObject : AXSprite {
    AXPoint speed;
    AXPoint rotationalSpeed;
}

@property (assign) AXPoint speed;
@property (assign) AXPoint rotationalSpeed;

- (void)checkArenaBounds;

@end
