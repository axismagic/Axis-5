//
//  AXTexturedButton.h
//  Axis
//
//  Created by Jethro Wilson on 01/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXButton.h"

@interface AXTexturedButton : AXButton {
    AXTexturedQuad *upQuad;
    AXTexturedQuad *downQuad;
}

- (id)initWithUpKey:(NSString*)upKey downKey:(NSString*)downKey;

@end
