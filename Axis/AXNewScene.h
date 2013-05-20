//
//  AXNewScene.h
//  Axis
//
//  Created by Jethro Wilson on 14/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXScene.h"

#import "AXMobileSprite.h"
#import "AXActionSet.h"

@class AXHeroOne;
@class AXEnemy;

@interface AXNewScene : AXScene <AXInputProtocol> {
    AXHeroOne *hero;
    AXEnemy *enemy;
}

@end
