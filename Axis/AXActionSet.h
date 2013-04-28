//
//  AXActionString.h
//  Axis
//
//  Created by Jethro Wilson on 24/04/2013.
//
//

#import "AXAction.h"

@interface AXActionSet : AXAction {
    NSInteger _actionSetRunMode;
    
    // actions
    NSMutableArray *actions;
}

@property (nonatomic, assign) NSInteger actionSetRunMode;

- (id)initWithActionRunMode:(NSInteger)runMode actions:(AXAction*)firstObject, ...;
- (void)addActions:(AXAction*)firstObject, ...;
- (void)addAction:(AXAction*)newAction;

- (NSArray*)allActions;

@end
