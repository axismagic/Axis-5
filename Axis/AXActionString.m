//
//  AXActionString.m
//  Axis
//
//  Created by Jethro Wilson on 24/04/2013.
//
//

#import "AXActionString.h"

@implementation AXActionString

@synthesize multiActionRunMode = _mutliActionRunMode;

- (void)dealloc {
    if (actions != nil)
        [actions release];
    if (actionsToRemove != nil)
        [actionsToRemove release];
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self != nil) {
        self.multiActionRunMode = kActionModeSimultaneous;
        
        self.actionType = 0;
        self.actionMode = 0;
        self.actionDuration = 0;
        self.actionReady = NO;
        
        self.actionFinishedCounter = 0;
        self.actionComplete = NO;
        
        self.desiredEffect = AXPointMake(0, 0, 0);
        self.startEffect = AXPointMake(0, 0, 0);
        self.endEffect = AXPointMake(0, 0, 0);
    }
    
    return self;
}

- (id)initWithActionMode:(NSInteger)mode actions:(AXAction*)firstObject, ... {
    self = [super init];
    if (self != nil) {
        // set mode
        self.multiActionRunMode = mode;
        
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

- (void)addAction:(AXAction*)newAction {
    if (actions == nil)
        actions = [[NSMutableArray alloc] init];
    
    [actions addObject:newAction];
}

#pragma mark Overridden

- (void)setActionType:(CGFloat)type mode:(CGFloat)mode effect:(AXPoint)effect duration:(CGFloat)duration {
    // create new action
    AXAction *newAction = [[AXAction alloc] init];
    [newAction setupActionWithType:type mode:mode effect:effect duration:duration];
    
    // add action to self
    [self addAction:newAction];
    [newAction release];
}

- (void)activateAction:(AXPoint)startEffect {
    
}

- (AXPoint)getActionFrameEffect {
    // depending on mode, get frame effects
    if (_mutliActionRunMode == kActionModeSimultaneous) {
        // get end frame effects
    } else if (_mutliActionRunMode == kActionModeSequence) {
        // get end frame effect for current first action
        [actions objectAtIndex:0];
    }
    
    return AXPointMake(0, 0, 0);
}

@end
