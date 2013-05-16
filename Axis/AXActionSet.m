//
//  AXActionSet.m
//  Axis
//
//  Created by Jethro Wilson on 24/04/2013.
//
//

#import "AXActionSet.h"

@implementation AXActionSet

@synthesize actionSetRunMode = _actionSetRunMode;

- (void)dealloc {
    if (actions != nil)
        [actions release];
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self != nil) {
        self.actionSetRunMode = AXACActionSetRunModeQueue;
        
        self.type = 0;
        self.mode = 0;
        self.duration = 1;
        self.durationFrames = 60;
        
        self.transformation = AXPointMake(0, 0, 0);
    }
    
    return self;
}

- (id)initWithActionRunMode:(NSInteger)runMode actions:(AXAction*)firstObject, ... {
    self = [super init];
    if (self != nil) {
        // set mode
        self.actionSetRunMode = runMode;
        
        if (actions == nil)
            actions = [[NSMutableArray alloc] init];
        
        id eachObject;
        va_list argumentList;
        if (firstObject) {
            // add first object
            [actions addObject:firstObject];
            // scan for objects after first
            va_start(argumentList, firstObject);
            while ((eachObject = va_arg(argumentList, id)))
                [actions addObject:eachObject];
            
            va_end(argumentList);
        }
    }
    
    return self;
}

- (void)addActions:(AXAction*)firstObject, ... {
    if (actions == nil)
        actions = [[NSMutableArray alloc] init];
    
    id eachObject;
    va_list argumentList;
    if (firstObject) {
        // add first object
        [actions addObject:firstObject];
        // scan for objects after first
        va_start(argumentList, firstObject);
        while ((eachObject = va_arg(argumentList, id)))
            [actions addObject:eachObject];
        
        va_end(argumentList);
    }
}

- (void)addAction:(AXAction*)newAction {
    if (actions == nil)
        actions = [[NSMutableArray alloc] init];
    
    [actions addObject:newAction];
}

#pragma mark Overridden

- (id)initWithTransformationType:(NSInteger)newType transformationMode:(NSInteger)newMode transformation:(AXPoint)newTransformation duration:(CGFloat)newDuration {
    // initialise self
    [self init];
    
    // add first action
    if (self != nil) {
        // create new action and add to self
        [self setupActionWithType:newType transformationMode:newMode transformation:newTransformation duration:newDuration];
    }
    
    return self;
}

- (void)setupActionWithType:(NSInteger)newType transformationMode:(NSInteger)newMode transformation:(AXPoint)newTransformation duration:(CGFloat)newDuration {
    // create new action and add to self
    AXAction *newAction = [[AXAction alloc] initWithTransformationType:newType transformationMode:newMode transformation:newTransformation duration:newDuration];
    [self addAction:newAction];
    [newAction release];
}

- (NSArray*)allActions {
    return actions;
}

@end
