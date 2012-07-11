//
//  AXAnimation.h
//  Axis
//
//  Created by Jethro Wilson on 03/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXSceneObject.h"

@interface AXAnimation : AXSceneObject

- (id)initWithAtlasKeys:(NSArray*)keys loops:(BOOL)loops speed:(NSInteger)speed;

@end
