//
//  AXSprite.m
//  Axis
//
//  Created by Jethro Wilson on 28/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXSpriteBase.h"

#import "AXCollider.h"

@implementation AXSpriteBase

@synthesize spriteDelegate = _spriteDelegate;
@synthesize mesh = _mesh, meshBounds = _meshBounds;
@synthesize collider = _collider;

- (id)init {
    self = [super init];
    if (self != nil) {
        
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (CGRect)meshBounds {
    if (CGRectEqualToRect(_meshBounds, CGRectZero))
        self.meshBounds = [AXMesh meshBounds:_mesh scale:_scale];
    
    return _meshBounds;
}

- (void)postUpdate {
    if (_collider != nil)
        [_collider updateCollider:self];
}

- (void)render {
    // if not active, do not render self or children
    if (!_active)
        return;
    
    // render children
    if (_hasChildren && !AX_ENABLE_RENDER_CHILDREN_ABOVE)
        [children makeObjectsPerformSelector:@selector(render)];
    
    // after rendering children, if no mesh, do not render self
    if (!_mesh) {
        // render children in case Renders children above and no mesh
        if (_hasChildren && AX_ENABLE_RENDER_CHILDREN_ABOVE)
            [children makeObjectsPerformSelector:@selector(render)];
        
        return;
    }
    
    glPushMatrix();
    glLoadIdentity();
    
    glMultMatrixf(self.matrix);
    
    [_mesh render];
    
    // restore matrix
    glPopMatrix();
    
    // render children
    if (_hasChildren && AX_ENABLE_RENDER_CHILDREN_ABOVE)
        [children makeObjectsPerformSelector:@selector(render)];
}

@end
