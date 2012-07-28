//
//  AXObject.m
//  Axis
//
//  Created by Jethro Wilson on 27/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXObject.h"

@implementation AXObject

@synthesize objectDelegate = _objectDelegate;
@synthesize vectorFromParent = _vectorFromParent;
@synthesize location = _location, rotation = _rotation, scale = _scale;
@synthesize matrix = _matrix;
@synthesize hasChildren = _hasChildren, isChild = _isChild;
@synthesize active = _active;

- (void)dealloc {
    self.matrix = nil;
    self.active = NO;
    [super dealloc];
}

#pragma mark -

- (void)awake {
    // override
    if (_objectDelegate)
        [_objectDelegate submitForEvaluation:self];
}

#pragma mark -
#pragma mark Update

- (void)update {
    // preUpdate
    [self preUpdate];
    
    // work out relative positions of children (their offset from self)
    if (_hasChildren) {
        // loop through children and work out relative position
        for (AXObject *child in children) {
            // work out relative position
            AXPoint childRelativePosition = AXPointMake(child.location.x - _location.x, 
                                                        child.location.y - _location.y,
                                                        child.location.z - _location.z);
            
            // give child new relative position
            child.vectorFromParent = childRelativePosition;
        }
    }
    
    // midPhase Updates - used in mobile object
    [self midPhaseUpdate];
    
    // update openGL on self
    glPushMatrix();
    glLoadIdentity();
    
    // move to my position
    glTranslatef(self.location.x, self.location.y, self.location.z);
    
    // rotate
    glRotatef(self.rotation.x, 1.0f, 0.0f, 0.0f);
    glRotatef(self.rotation.y, 0.0f, 1.0f, 0.0f);
    glRotatef(self.rotation.z, 0.0f, 0.0f, 1.0f);
    
    // scale
    glScalef(self.scale.x, self.scale.y, self.scale.z);
    
    // save matrix
    glGetFloatv(GL_MODELVIEW_MATRIX, self.matrix);
    // restore matrix
    glPopMatrix();
    
    // ***** update collider? - perhaps in sprite, moved to postUpdate
    
    // update children with new positions from thier saved relative ones
    if (_hasChildren) {
        for (AXObject *child in children) {
            AXPoint childNewPosition = AXPointMake(_location.x + child.vectorFromParent.x,
                                                   _location.y + child.vectorFromParent.y,
                                                   _location.z + child.location.z);
            
            child.location = childNewPosition;
        }
        
        // update all children
        [children makeObjectsPerformSelector:@selector(update)];
    }
    
    // postUpdate
    [self postUpdate];
}

- (void)preUpdate {
    
}

- (void)midPhaseUpdate {
    /* Overridden in Mobile object to apply changes before updated by OpenGL */
}

- (void)postUpdate {
    /* ***** potentially used in sprite to add collider. */
}

#pragma mark Render

/* overridden by sprite - this method serves to ensure the object, if used on its own to control children, will render the children. AXScene overrides this to ensure the interface is rendered above everything else. */
- (void)render {
    // render children
    if (_hasChildren)
        [children makeObjectsPerformSelector:@selector(render)];
}

#pragma mark Child Control

// ***** addChild:(AXObject*)child forKey:(NSString*)key
- (void)addChild:(AXObject *)child {
    if (children == nil)
        children = [[NSMutableArray alloc] init];
    
    // if child is not already owned, add new child
    NSAssert(!child.isChild, @"Child must not be owned");
    
    // activate ***** consider at end?
    child.active = YES;
    child.isChild = YES;
    if (!_hasChildren)
        self.hasChildren = YES;
    
    // delegate
    child.objectDelegate = _objectDelegate;
    
    // awake child
    [child awake];
    // add to children array
    [children addObject:child];
}

- (void)removeChild:(NSString *)childKey {
    
}

@end
