//
//  AXInputViewControllerViewController.m
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXInputViewController.h"

#import "AXButton.h"
#import "AXArrowButton.h"
#import "AXTexturedButton.h"
#import "AXInputHandler.h"

@implementation AXInputViewController

@synthesize inputActive = _inputActive, loopLock = _loopLock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // initialise touch storage set
        _loopLock = NO;
    }
    
    return self;
}

- (void)loadView {
    
}

- (CGRect)screenRectFromMeshRect:(CGRect)rect atPoint:(CGPoint)meshCenter {
    CGPoint screenCenter = CGPointZero;
    CGPoint rectOrigin = CGPointZero;
    // since view is rotated, x and y are flipped
    // *****
    CGFloat vWidth = [AXDirector sharedDirector].viewSize.width;
    CGFloat vHeight = [AXDirector sharedDirector].viewSize.height;
    
    screenCenter.x = meshCenter.y + vWidth/2;
    screenCenter.y = meshCenter.x + vHeight/2;
    
    rectOrigin.x = screenCenter.x - (CGRectGetHeight(rect)/2.0);
    rectOrigin.y = screenCenter.y - (CGRectGetWidth(rect)/2.0);
    
    return CGRectMake(rectOrigin.x, rectOrigin.y, CGRectGetHeight(rect), CGRectGetWidth(rect));
}

#pragma mark - Object Registration

- (void)registerObjectForTouches:(AXObject *)object swallowsTouchesType:(AXInputObjectSwallowType)swallowType {
    // create handler for object
    AXInputHandler *handler = [[AXInputHandler alloc] initWithRegisteredObject:object swallowType:swallowType];
    
    // if loop is locked, add to toAdd
    if (self.loopLock) {
        if (_handlersToAdd == nil)
            _handlersToAdd = [[NSMutableSet alloc] init];
        
        [_handlersToAdd addObject:handler];
    } else {
        NSLog(@"Added Handler from outside of loop lock");
        // Loop not locked, add to appropriate set
        if (swallowType == AXInputObjectSwallows) {
            // swallows touches, wants only its touches
            if (_registeredSwallowingObjects == nil)
                _registeredSwallowingObjects = [[NSMutableSet alloc] init];
            [_registeredSwallowingObjects addObject:handler];
        } else if (swallowType == AXInputObjectWantsRemaining) {
            // wants remaining after swalloing objects have claimed their touches
            if (_registeredRemainingObjects == nil)
                _registeredRemainingObjects = [[NSMutableSet alloc] init];
            [_registeredRemainingObjects addObject:handler];
        } else if (swallowType == AXInputObjectWantsAll) {
            // wants all touches
            if (_registeredObjects == nil)
                _registeredObjects = [[NSMutableSet alloc] init];
            [_registeredObjects addObject:handler];
        }
    }
}

- (void)unregisterObjectForTouches:(AXObject*)object {
    // if loop is locked, add to toRemove
    if (self.loopLock) {
        if (_handlersToRemove == nil)
            _handlersToRemove = [[NSMutableSet alloc] init];
        
        [_handlersToRemove addObject:object];
    } else {
        // Loop is not locked, remove object from handlers
        for (AXInputHandler *handler in _registeredSwallowingObjects) {
            if (handler.object == object) {
                [_registeredSwallowingObjects removeObject:handler];
                return;
            }
        }
        
        for (AXInputHandler *handler in _registeredRemainingObjects) {
            if (handler.object == object) {
                [_registeredRemainingObjects removeObject:handler];
                return;
            }
        }
        
        for (AXInputHandler *handler in _registeredObjects) {
            if (handler.object == object) {
                [_registeredObjects removeObject:handler];
                return;
            }
        }
        
        NSLog(@"WARN: Object did not get unregistered for touches as was not found in registration set.");
    }
}

- (void)unregisterObjectForTouches:(AXObject *)object swallowsTouchesType:(AXInputObjectSwallowType)swallowType {
    // if loop is locked, add to toRemove
    if (self.loopLock) {
        if (_handlersToRemove == nil)
            _handlersToRemove = [[NSMutableSet alloc] init];
        
        [_handlersToRemove addObject:object];
        
        NSLog(@"NOTE: Loop was locked, object will be removed later at end of current loop.");
        NSLog(@"POI.: All sets will be searched at end of loop, resulting in same performance as unregisterObjectForTouches: as opposed to enhanced performance from unregisterObjectForTouches:swallowTouchesType:");
    } else {
        // remove object for touch type
        if (swallowType == AXInputObjectSwallows) {
            for (AXInputHandler *handler in _registeredSwallowingObjects) {
                if (handler.object == object) {
                    [_registeredSwallowingObjects removeObject:handler];
                    return;
                }
            }
            NSLog(@"WARN: Object did not get unregistered for touches as was not found in specified registration set: Swallowing Touches Type");
        }
        
        // remove object for touch type
        else if (swallowType == AXInputObjectWantsRemaining) {
            for (AXInputHandler *handler in _registeredRemainingObjects) {
                if (handler.object == object) {
                    [_registeredRemainingObjects removeObject:handler];
                    return;
                }
            }
            NSLog(@"WARN: Object did not get unregistered for touches as was not found in specified registration set: Wants Remaining Touches Type");
        }
        
        // remove object for touch type
        else if (swallowType == AXInputObjectWantsAll) {
            for (AXInputHandler *handler in _registeredObjects) {
                if (handler.object == object) {
                    [_registeredObjects removeObject:handler];
                    return;
                }
            }
            NSLog(@"WARN: Object did not get unregistered for touches as was not found in specified registration set: Wants All Touches Type");
        }
    }
}

#pragma mark Touch Event Handlers

- (void)touches:(NSSet *)touches withEvent:(UIEvent *)event touchTypeSelector:(SEL)touchTypeSelector {
    // duplicate touches to allow for touches to be removed
    BOOL needsTouchesCopy = NO;
    id touchesRemaining;
    if ([_registeredSwallowingObjects count] > 0) {
        needsTouchesCopy = YES;
        touchesRemaining = [touches mutableCopy];
    }
    
    // activate Loop Lock to prevent arrays changing as iterating over
    self.loopLock = YES;
    
    // swallowing touch type objects
    if (needsTouchesCopy) {
        for (UITouch *touch in touches) {
            //for (AXObject *object in _registeredSwallowingObjects) {
            for (AXInputHandler *handler in _registeredSwallowingObjects) {
                // find out if object wants touch
                BOOL claimedTouch = NO;
                
                // if touches began, we are sending out touches to be claimed
                if (touchTypeSelector == @selector(axTouchesBegan:withEvent:)) {
                    // touches began, send touch to object
                    if ([[handler object] respondsToSelector:@selector(axTouchIsMine:)]) {
                        if ([[handler object] axTouchIsMine:touch]) {
                            // touch is claimed
                            claimedTouch = YES;
                            // add touch to object
                            [handler.claimedTouches addObject:touch];
                        }
                    } else {
                        NSLog(@"WARN: Object claims to swallow touches, but has not implemented -(BOOL)axTouchIsMine:(UITouch*)touch");
                    }
                }
                // touches moved, cancelled or ended
                else if ([handler.claimedTouches containsObject:touch]) {
                    // touch already belongs to this object,
                    claimedTouch = YES;
                    // if touch ended, add to ended touches removal set
                    if (touchTypeSelector == @selector(axTouchesCancelled:withEvent:) || touchTypeSelector == @selector(axTouchesEnded:withEvent:)) {
                        // touch ended, still dispatch but remove afterwards
                        [handler.endedTouches addObject:touch];
                    }
                }
                
                // if touch was claimed, break from checking objects against this touch and move onto next touch
                if (claimedTouch) {
                    // remove touch from set
                    [touchesRemaining removeObject:touch];
                    // break from checking this touch
                    break;
                }
            }
        }
        
        // dispatch touch events for swallowing objects
        for (AXInputHandler *handler in _registeredSwallowingObjects) {
            // tell handler to dispatch claimed touches to its object
            [handler dispatchClaimedTouchesWithSelector:touchTypeSelector withEvent:event];
        }
        
        // if there are touches remaining, dispatch them to non swallowing, remaining type objects
        if ([touchesRemaining count] > 0) {
            // dispatch touch events for touch remaining objects
            for (AXInputHandler *handler in _registeredRemainingObjects) {
                // tell handler to dispatch provided touches to its object
                [handler dispatchTouches:touchesRemaining withEvent:event selector:touchTypeSelector];
            }
        }
        
        // release touches remaining
        [touchesRemaining release];
    }
    
    // all touch type objects
    for (AXInputHandler *handler in _registeredObjects) {
        // send all touches
        [handler dispatchTouches:touches withEvent:event selector:touchTypeSelector];
    }
    
    // deactivate loop lock
    self.loopLock = NO;
    
    // Add new handlers
    if ([_handlersToAdd count] > 0) {
        // add new handlers
        for (AXInputHandler *handler in _handlersToAdd) {
            // Loop not locked, add to appropriate set
            if (handler.swallowType == AXInputObjectSwallows) {
                // swallows touches, wants only its touches
                if (_registeredSwallowingObjects == nil)
                    _registeredSwallowingObjects = [[NSMutableSet alloc] init];
                [_registeredSwallowingObjects addObject:handler];
            } else if (handler.swallowType == AXInputObjectWantsRemaining) {
                // wants remaining after swalloing objects have claimed their touches
                if (_registeredRemainingObjects == nil)
                    _registeredRemainingObjects = [[NSMutableSet alloc] init];
                [_registeredRemainingObjects addObject:handler];
            } else if (handler.swallowType == AXInputObjectWantsAll) {
                // wants all touches
                if (_registeredObjects == nil)
                    _registeredObjects = [[NSMutableSet alloc] init];
                [_registeredObjects addObject:handler];
            }
        }
        [_handlersToAdd removeAllObjects];
    }
    
    // remove old handlers
    if ([_handlersToRemove count] > 0) {
        for (AXObject *object in _handlersToRemove) {
            [self unregisterObjectForTouches:object];
        }
        [_handlersToRemove removeAllObjects];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touches:touches withEvent:event touchTypeSelector:@selector(axTouchesBegan:withEvent:)];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touches:touches withEvent:event touchTypeSelector:@selector(axTouchesMoved:withEvent:)];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touches:touches withEvent:event touchTypeSelector:@selector(axTouchesEnded:withEvent:)];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touches:touches withEvent:event touchTypeSelector:@selector(axTouchesCancelled:withEvent:)];
}


#pragma mark Unload, Dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc {
    [super dealloc];
}

@end
