//
//  AXObject.m
//  Axis
//
//  Created by Jethro Wilson on 27/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXObject.h"

@implementation AXObject

@synthesize sceneDelegate = _sceneDelegate, parentDelegate = _parentDelegate;
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

- (id)init {
    self = [super init];
    if (self != nil) {
        self.sceneDelegate = nil;
        self.parentDelegate = nil;
    }
    
    return self;
}

- (void)awake {
    // override
    if (_sceneDelegate)
        [_sceneDelegate addObjectCollider:self];
}

#pragma mark -
#pragma mark Update

- (void)update {
    // preUpdate
    [self preUpdate];
    
    // add new objects
    if ([childrenToAdd count] > 0) {
        if (children == nil)
            children = [[NSMutableArray alloc] init];
        
        [children addObjectsFromArray:childrenToAdd];
        [childrenToAdd removeAllObjects];
    }
    
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
    
    // remove old child objects
    if ([childrenToRemove count] > 0) {
        [children removeObjectsInArray:childrenToRemove];
        [childrenToRemove removeAllObjects];
        
        if ([children count] == 0)
            self.hasChildren = NO;
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

#pragma mark -
#pragma mark Child Control

// ***** addChild:(AXObject*)child forKey:(NSString*)key
- (void)addChild:(AXObject *)child {
    if (childrenToAdd == nil)
        childrenToAdd = [[NSMutableArray alloc] init];
    
    // if child is not already owned, add new child
    NSAssert(!child.isChild, @"Child must not be owned");
    
    // activate ***** consider at end?
    child.active = YES;
    child.isChild = YES;
    if (!_hasChildren)
        self.hasChildren = YES;
    
    // delegate
    child.sceneDelegate = _sceneDelegate;
    child.parentDelegate = self;
    
    // awake child
    [child awake];
    // add to children array
    [childrenToAdd addObject:child];
}

- (void)removeChild:(AXObject*)object {
    if (childrenToRemove == nil)
        childrenToRemove = [[NSMutableArray alloc] init];
    
    // object must be child
    NSAssert(object.isChild, @"Object must be child");
    
    // remove collider
    [object.sceneDelegate removeObjectCollider:object];
    
    // remove child
    [childrenToRemove addObject:object];
}

#pragma mark Delegate Parent Methods
/* Messages from child */

- (void)addObjectToParent:(AXObject *)object {
    [self addChild:object];
}

- (void)removeObjectFromParent:(AXObject *)object {
    [self removeChild:object];
}

@end
