//
//  AXActivitySet.m
//  Axis
//
//  Created by Jethro Wilson on 28/04/2013.
//
//

#import "AXActivitySet.h"

#import "AXActionSet.h"

@implementation AXActivitySet

@synthesize activitySetRunMode = _activitySetRunMode;

- (id)init {
    self = [super init];
    if (self != nil) {
        self.activitySetRunMode = AXACActionSetRunModeQueue;
        
        self.type = AXACTypeSet;
    }
    
    return self;
}

- (id)initWithActionSet:(AXActionSet *)actionSet {
    [self init];
    
    [self setupWithActionSet:actionSet];
    
    return self;
}

#pragma mark setup

- (void)setupWithActionSet:(AXActionSet *)actionSet {
    // create actions with action set
    self.type = actionSet.type;
    self.mode = actionSet.mode;
    self.duration = actionSet.duration;
    self.durationFrames = actionSet.durationFrames;
    
    self.transformation = actionSet.transformation;
    
    self.activitySetRunMode = actionSet.actionSetRunMode;
    
    // loop through actions and add top self
    NSArray *actionsToConvert = [[NSArray alloc] initWithArray:[actionSet allActions]];
    if (activities == nil)
        activities = [[NSMutableArray alloc] init];
    
    for (AXAction *newAction in actionsToConvert) {
        // if is action set, add that instead
        if ([newAction isKindOfClass:[AXActionSet class]]) {
            AXActivitySet *newActivitySet = [[AXActivitySet alloc] initWithActionSet:(AXActionSet*)newAction];
            [activities addObject:newActivitySet];
        } else {
            AXActivity *newActivity = [[AXActivity alloc] initWithAction:newAction];
            [activities addObject:newActivity];
        }
    }
    [actionsToConvert release];
}

#pragma mark - Overriden

- (BOOL)activate {
    if (_delegate != nil) {
        // loop through activities and activate them
        for (AXActivity *act in activities) {
            [act setDelegate:_delegate];
            [act activate];
        }
    
        self.activated = YES;
        self.complete = NO;
        self.activityCounter = 0;
        
        return YES;
    } else {
        // failed to activate
        return NO;
    }
}

- (void)makeFrameTransformation {
    // loop through activities
    if (_activated && !_complete) {
        // depending on mode, update objectAtIndex:0, or all
        if (_activitySetRunMode == AXACActionSetRunModeQueue) {
            // get object at index 0 only
            AXActivity *currentActivity = [[AXActivity alloc] init];
            currentActivity = [activities objectAtIndex:0];
            
            [currentActivity makeFrameTransformation];
            
            if (currentActivity.complete) {
                // check array
                if (activitiesToRemove == nil)
                    activitiesToRemove = [[NSMutableArray alloc] init];
                // remove activity
                [activitiesToRemove addObject:currentActivity];
            }
        } else if (_activitySetRunMode == AXACActionSetRunModeSimultaneous) {
            // update all activities
            for (AXActivity *currentAct in activities) {
                [currentAct makeFrameTransformation];
                if (currentAct.complete) {
                    // check array
                    if (activitiesToRemove == nil)
                        activitiesToRemove = [[NSMutableArray alloc] init];
                    [activitiesToRemove addObject:currentAct];
                }
            }
        }
        
        // remove activities that are complete
        if ([activitiesToRemove count] > 0) {
            [activities removeObjectsInArray:activitiesToRemove];
            [activitiesToRemove removeAllObjects];
        }
        
        // check if complete
        if ([activities count] == 0) {
            self.complete = YES;
        }
    }
}

#pragma mark Overriden Non Essentail

// Creation?

@end
