//
//  AXObject.m
//  Axis
//
//  Created by Jethro Wilson on 27/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXObject.h"

#import "AXMatrix.h"
#import "AXConfiguration.h"

@implementation AXObject

@synthesize sceneDelegate = _sceneDelegate, parentDelegate = _parentDelegate;
@synthesize vectorFromParent = _vectorFromParent;
@synthesize location = _location, rotation = _rotation, scale = _scale;
@synthesize matrix = _matrix, parentMatrix = _parentMatrix;
@synthesize hasChildren = _hasChildren, isChild = _isChild;
@synthesize active = _active, updates = _updates, renders = _renders;
@synthesize actionQueueMode = _actionQueueMode;

- (void)dealloc {
    self.matrix = nil;
    self.active = NO;
    [super dealloc];
}

#pragma mark -

- (id)init {
    self = [super init];
    if (self != nil) {
        _sceneDelegate = nil;
        _parentDelegate = nil;
        
        _vectorFromParent = AXPointMake(0.0, 0.0, 0.0);
        
        _location = AXPointMake(0.0, 0.0, 0.0);
        _rotation = AXPointMake(0.0, 0.0, 0.0);
        _scale = AXPointMake(1.0, 1.0, 1.0);
        
        _matrix = AXMatrixAlloc();
        _parentMatrix = AXMatrixAlloc();
        
        _hasChildren = NO;
        _isChild = NO;
        
        _active = NO;
        
        _actionQueueMode = AXACQueueSetQueue;
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
    
    // add new objects
    if ([childrenToAdd count] > 0) {
        if (children == nil)
            children = [[NSMutableArray alloc] init];
        
        [children addObjectsFromArray:childrenToAdd];
        [childrenToAdd removeAllObjects];
    }
    
    if (_updates) {
        
        // update actions
        [self updateActions];
        
        // update openGL on self
        glPushMatrix();
        if (AX_ENABLE_CUSTOM_MATRIX_MATHS) { // use custom AXMatrix calls for speed, performance and extra features
            // build transform matrix
            GLfloat *translationMatrix = AXMatrixAlloc();
            AXMatrixBuildTranslation(translationMatrix, self.location.x, self.location.y, self.location.z);
            // build rotation matrixes
            GLfloat *rotationXMatrix = AXMatrixAlloc();
            AXMatrixBuildRotationByDegrees(rotationXMatrix, self.rotation.x, 1.0f, 0.0f, 0.0f);
            GLfloat *rotationYMatrix = AXMatrixAlloc();
            AXMatrixBuildRotationByDegrees(rotationYMatrix, self.rotation.y, 0.0f, 1.0f, 0.0f);
            GLfloat *rotationZMatrix = AXMatrixAlloc();
            AXMatrixBuildRotationByDegrees(rotationZMatrix, self.rotation.z, 0.0f, 0.0f, 1.0f);
            
            GLfloat *scaleMatrix = AXMatrixAlloc();
            AXMatrixBuildScale(scaleMatrix, self.scale.x, self.scale.y, self.scale.z);
            
            // ***** add shear GLfloat *shearMatrix = AXMatrixAlloc();
            
            // multiply matrixes
            GLfloat *tempMatrix1 = AXMatrixAlloc();
            GLfloat *tempMatrix2 = AXMatrixAlloc();
            GLfloat *tempMatrix3 = AXMatrixAlloc();
            GLfloat *tempMatrix4 = AXMatrixAlloc();
            GLfloat *finalMatrix = AXMatrixAlloc();
            AXMatrixMultiply(self.parentMatrix, translationMatrix, tempMatrix1);
            AXMatrixMultiply(tempMatrix1, rotationXMatrix, tempMatrix2);
            AXMatrixMultiply(tempMatrix2, rotationYMatrix, tempMatrix3);
            AXMatrixMultiply(tempMatrix3, rotationZMatrix, tempMatrix4);
            AXMatrixMultiply(tempMatrix4, scaleMatrix, finalMatrix);
            
            glLoadMatrixf(finalMatrix);
            
            free(tempMatrix1);
            free(tempMatrix2);
            free(tempMatrix3);
            free(tempMatrix4);
            free(finalMatrix);
            free(translationMatrix);
            free(rotationXMatrix);
            free(rotationYMatrix);
            free(rotationZMatrix);
            free(scaleMatrix);
            
        } else { // use standard OpenGL calls
            // inherit coordinate system
            glLoadMatrixf(self.parentMatrix);
            
            // update position
            glTranslatef(self.location.x, self.location.y, self.location.z);
            
            // update rotation
            glRotatef(self.rotation.x, 1.0f, 0.0f, 0.0f);
            glRotatef(self.rotation.y, 0.0f, 1.0f, 0.0f);
            glRotatef(self.rotation.z, 0.0f, 0.0f, 1.0f);
            
            // update scale
            glScalef(self.scale.x, self.scale.y, self.scale.z);
        }
        
        // save matrix
        glGetFloatv(GL_MODELVIEW_MATRIX, self.matrix);
        // restore matrix
        glPopMatrix();
    }
    
    // update children with new positions from thier saved relative ones
    if (_hasChildren) {
        for (AXObject *child in children) {
            // set child coordinate system as our own
            child.parentMatrix = self.matrix;
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
    NSAssert(!child.isChild, @"Child must not be owned already");
    
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
    // grab new action from queue if no activities
    if ([activities count] == 0) {
        // grab new action
        if ([actions count] > 0) {
            
            
            /*// check queue mode
            if (_actionQueueMode == AXACQueueSetNoQueue_RunAllSimultaneous) {
                // grab all actions and run simultaneously
                for (AXAction *newAction in actions) {
                    AXActivity *newActivity = [[self interpretAction:newAction] retain];
                    [activities addObject:newActivity];
                    [newActivity release];
                }
                // clear actions
                [actions removeAllObjects];
            } else {*/
            if (_actionQueueMode == AXACQueueSetQueue) {
                // check arrays
                if (activities == nil)
                    activities = [[NSMutableArray alloc] init];
                
                // grab top action - standard queue mode
                AXAction *topAction = [actions objectAtIndex:0];
                AXActivity *newActivity = [[self interpretAction:topAction] retain];
                // add activity to array
                [activities addObject:newActivity];
                // cleanup
                [actions removeObjectAtIndex:0];
                [newActivity release];
            } else {
                NSLog(@"Error, Action misshandled - is in queue but object mode set to no queue");
            }
        }
    }
    
    // loop through activities
    if ([activities count] > 0) {
        for (AXActivity *currentActivity in activities) {
            // get the frame effect
            [currentActivity makeFrameTransformation];
            
            if (currentActivity.complete) {
                if (activitiesToRemove == nil)
                    activitiesToRemove = [[NSMutableArray alloc] init];
                
                // remove activity
                [activitiesToRemove addObject:currentActivity];
            }
        }
    }
    
    if ([activitiesToRemove count] > 0) {
        [activities removeObjectsInArray:activitiesToRemove];
        [activitiesToRemove removeAllObjects];
    }
}

- (AXActivity*)interpretAction:(AXAction*)newAction {
    // check if activity or set
    if ([newAction isKindOfClass:[AXActionSet class]]) {
        // create activity set
        AXActivitySet *newSet = [[AXActivitySet alloc] initWithActionSet:(AXActionSet*)newAction];
        [newSet setDelegate:self];
        if ([newSet activate]) {
            return newSet;
        } else {
            NSLog(@"Set failed to activate");
            return nil;
        }
    } else {
        // create activity from action
        AXActivity *newActivity = [[AXActivity alloc] initWithAction:newAction];
        [newActivity setDelegate:self];
        if ([newActivity activate]) {
            return newActivity;
        } else {
            NSLog(@"activity failed to activate");
            return nil;
        }
    }
}

- (void)performAction:(AXAction *)action {
    // check queue mode
    if (_actionQueueMode == AXACQueueSetNoQueue_IgnoreNew && [activities count] > 0)
        return; // ignores new actions if currently running through actvities
    else if (_actionQueueMode == AXACQueueSetNoQueue_IgnoreNew) {
        // add new action directly, skip queue; as no current activity
        if (activities == nil)
            activities = [[NSMutableArray alloc] init];
        
        AXActivity *newActivity = [self interpretAction:action];
        // add activity to array
        [activities addObject:newActivity];
        
        // skip add to queue as now done
        return;
        
    }
    if (_actionQueueMode == AXACQueueSetNoQueue_InterruptCurrent) {
        if (activities == nil)
            activities = [[NSMutableArray alloc] init];
        // remove current activities
        [activities removeAllObjects];
        
        // add new activity straight away
        AXActivity *newActivity = [self interpretAction:action];
        [activities addObject:newActivity];
        
        return;
    }
    
    if (_actionQueueMode == AXACQueueSetNoQueue_RunAllSimultaneous) {
        // add new action directly, skip queue; as all simultaneous
        if (activities == nil)
            activities = [[NSMutableArray alloc] init];
        
        AXActivity *newActivity = [self interpretAction:action];
        // add activity to array
        [activities addObject:newActivity];
        
        // skip add to queue as now done
        return;
    }
    
    if (actions == nil)
        actions = [[NSMutableArray alloc] init];
    
    // add to queue
    [actions addObject:action];
}

#pragma mark Activity Delegate Methods

- (AXPoint)returnCurrentTrasnformationForType:(NSInteger)type {
    if (type == AXACTransformationMovement)
        return self.location;
    else if (type == AXACTransformationScale)
        return self.scale;
    else if (type == AXACTransformationRotation)
        return self.rotation;
    else {
        NSLog(@"Failed to match type to activity mode");
        return AXPointMake(0, 0, 0);
    }
}

- (void)updateWithTransformation:(AXPoint)transformationUpdate type:(NSInteger)type {
    if (type == AXACTransformationMovement) {
        self.location = AXPointAdd(_location, transformationUpdate);
    } else if (type == AXACTransformationScale) {
        self.scale = AXPointAdd(_scale, transformationUpdate);
    } else if (type == AXACTransformationRotation) {
        self.rotation = AXPointAdd(_rotation, transformationUpdate);
    }
}

/*- (AXPoint)requestCurrentActionStateForMode:(CGFloat)mode {
    // Rather than action being activated by the AXObject, action activates itself and requests required details from object through protocols.
    
    AXPoint actionState = AXPointMake(0, 0, 0);
    
    if (mode == kATmovement)
        actionState = self.location;
    else if (mode == kATscale)
        actionState = self.scale;
    else if (mode == kATrotation)
        actionState = self.rotation;
    
    return actionState;
}

- (void)updateState:(CGFloat)state withEffect:(AXPoint)effect {
    if (state == kATmovement)
        self.location = AXPointAdd(_location, effect);
    else if (state == kATscale)
        self.location = AXPointAdd(_location, effect);
    else if (state == kATrotation)
        self.location = AXPointAdd(_location, effect);
}*/

@end
