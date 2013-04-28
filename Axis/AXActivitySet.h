//
//  AXActivitySet.h
//  Axis
//
//  Created by Jethro Wilson on 28/04/2013.
//
//

#import "AXActivity.h"

@class AXActionSet;

@interface AXActivitySet : AXActivity {
    // Activity Run Mode
    NSInteger _activitySetRunMode;
    
    // Activities
    NSMutableArray *activities;
    NSMutableArray *activitiesToRemove;
}

@property (nonatomic, assign) NSInteger activitySetRunMode;

// create ActivitySet From ActionSet
- (id)initWithActionSet:(AXActionSet*)actionSet;
- (void)setupWithActionSet:(AXActionSet*)actionSet;

@end
