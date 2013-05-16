//
//  AXTexturedButton.m
//  Axis
//
//  Created by Jethro Wilson on 01/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXTexturedButton.h"

@implementation AXTexturedButton

- (id)initWithUpKey:(NSString *)upKey downKey:(NSString *)downKey {
    self = [super init];
    if (self != nil) {
        upQuad = [[AXMaterialController sharedMaterialController] quadFromAtlasKey:upKey];
        downQuad = [[AXMaterialController sharedMaterialController] quadFromAtlasKey:downKey];
        
        [upQuad retain];
        [downQuad retain];
    }
    
    return self;
}

- (void)awake {
    [self setNotPressedVertexes];
    screenRect = [[AXDirector sharedDirector].inputController screenRectFromMeshRect:self.meshBounds atPoint:CGPointMake(_location.x, _location.y)];
}

- (void)setNotPressedVertexes {
    self.mesh = upQuad;
}

- (void)setPressedVertexes {
    self.mesh = downQuad;
}

@end
