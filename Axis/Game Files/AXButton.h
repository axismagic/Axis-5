//
//  AXButton.h
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXSprite.h"

@interface AXButton : AXSprite {
    BOOL pressed;
    id target;
    SEL buttonDownAction;
    SEL buttonUpAction;
    CGRect screenRect;
}

@property (assign) id target;
@property (assign) SEL buttonDownAction;
@property (assign) SEL buttonUpAction;

- (void)handleTouches;
- (void)touchDown;
- (void)touchUp;

- (void)setPressedVertexes;
- (void)setNotPressedVertexes;

@end
