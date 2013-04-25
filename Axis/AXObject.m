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
@synthesize active = _active, updates = _updates, renders = _renders;
@synthesize actionConflictionMode = _actionConflictionMode;

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
        
        self.vectorFromParent = AXPointMake(0.0, 0.0, 0.0);
        
        self.location = AXPointMake(0.0, 0.0, 0.0);
        self.rotation = AXPointMake(0.0, 0.0, 0.0);
        self.scale = AXPointMake(1.0, 1.0, 1.0);
        
        self.matrix = (CGFloat*) malloc(16 * sizeof(CGFloat));
        
        self.hasChildren = NO;
        self.isChild = NO;
        
        self.active = NO;
        
        self.actionConflictionMode = kActionConflictionAcceptAll;
    }
    
    return self;
}

#pragma mark - Activation

- (void)activate {
    self.active = YES;
    self.updates = YES;
    self.renders = YES;
}

- (void)deactivate {
    self.active = NO;
    self.updates = NO;
    self.renders = NO;
}

- (void)awake {
    // *R?* remove awake methods
    // override
    if (_sceneDelegate)
        [_sceneDelegate addObjectCollider:self];
}

#pragma mark -
#pragma mark Update

- (void)update {
    // if not active, do not update self or children
    if (!_active)
        return;
    
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
    
    if (_updates) {
        
        // update actions
        [self updateActions];
    
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
        
        [self secondMidPhaseUpdate];
        
        // scale
        glScalef(self.scale.x, self.scale.y, self.scale.z);
        
        // save matrix
        glGetFloatv(GL_MODELVIEW_MATRIX, self.matrix);
        // restore matrix
        glPopMatrix();
    }
    
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

- (void)secondMidPhaseUpdate {
    // ***** arrange better?
    /* Overridden by AXSprite to adjust size */
}

- (void)postUpdate {
    /* ***** potentially used in sprite to add collider. */
}

#pragma mark Render

/* overridden by sprite - this method serves to ensure the object, if used on its own to control children, will render the children. AXScene overrides this to ensure the interface is rendered above everything else. */
- (void)render {
    // if not active, do not render children
    if (!_active)
        return;
    
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
    
    child.isChild = YES;
    if (!_hasChildren)
        self.hasChildren = YES;
    
    // delegate
    child.sceneDelegate = _sceneDelegate;
    child.parentDelegate = self;
    
    // add to children array
    [childrenToAdd addObject:child];
}

- (void)removeChild:(AXObject*)child {
    if (childrenToRemove == nil)
        childrenToRemove = [[NSMutableArray alloc] init];
    
    // object must be child
    NSAssert(child.isChild, @"Object must be child");
    
    // remove collider
    // [object.sceneDelegate removeObjectCollider:object];
    
    // deactivate object
    [child deactivate]; 
    
    // remove child
    [childrenToRemove addObject:child];
}

#pragma mark Delegate Parent Methods
/* Messages from child */

- (void)addObjectToParent:(AXObject *)object {
    [self addChild:object];
}

- (void)removeObjectFromParent:(AXObject *)object {
    [self removeChild:object];
}

#pragma mark - Action Control

- (void)updateActions {
    // loop actions
    if ([actions count] > 0) {
        for (AXAction *action in actions) {
            if (action.actionType == kATmovement) {
                AXPoint frameEffect = [action getActionFrameEffect];
                
                self.location = AXPointAdd(self.location, frameEffect);
            } else if (action.actionType == kATscale) {
                AXPoint frameEffect = [action getActionFrameEffect];
                
                self.scale = AXPointMake(self.scale.x + frameEffect.x, self.scale.y + frameEffect.y, self.scale.z + frameEffect.z);
            } else if (action.actionType == kATrotation) {
                AXPoint frameEffect = [action getActionFrameEffect];
                
                self.rotation = AXPointMake(self.rotation.x + frameEffect.x, self.rotation.y + frameEffect.y, self.rotation.z + frameEffect.z);
            }
            
            if (action.actionComplete)
                [actionsToRemove addObject:action];
        }
    }
    
    if ([actionsToRemove count] > 0) {
        [actions removeObjectsInArray:actionsToRemove];
        [actionsToRemove removeAllObjects];
    }
}

- (void)performAction:(AXAction*)action {
    if (actions == nil)
        actions = [[NSMutableArray alloc] init];
    if (actionsToRemove == nil)
        actionsToRemove = [[NSMutableArray alloc] init];
    
    // ***** check confliction mode first
    if (_actionConflictionMode != kActionConflictionAcceptAll) {
        // **** what to do for strings? ??free pass??
        for (AXAction *eAction in actions) {
            if (_actionConflictionMode == kActionConflictionRemoveNew) {
                if (eAction.actionMode == action.actionMode)
                    return;
            } else if (_actionConflictionMode == kActionConflictionRemoveExisting) {
                if (eAction.actionMode == action.actionMode) {
                    // remove old action
                    [actionsToRemove addObject:eAction];
                    break;
                }
            }
        }
    }
    
    if ([actionsToRemove count] > 0) {
        [actions removeObjectsInArray:actionsToRemove];
        [actionsToRemove removeAllObjects];
    }
    
    // make self delegate
    [action setObjectDelegate:self];
    // activate action
    [action activateAction];
    // add action
    [actions addObject:action];
}

#pragma mark Action Delegate Methods

- (AXPoint)requestCurrentActionStateForMode:(CGFloat)mode {
    /* Rather than action being activated by the AXObject, action activates itself and requests required details from object through protocols.
     */
    AXPoint actionState = AXPointMake(0, 0, 0);
    
    if (mode == kATmovement)
        actionState = self.location;
    else if (mode == kATscale)
        actionState = self.scale;
    else if (mode == kATrotation)
        actionState = self.rotation;
    
    return actionState;
}

@end
