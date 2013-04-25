//
//  AXActionString.h
//  Axis
//
//  Created by Jethro Wilson on 24/04/2013.
//
//

#import "AXAction.h"

enum eActionModes {
    kActionModeSimultaneous = 1,
    kActionModeSequence = 2
    };

@interface AXActionString : AXAction {
    NSInteger _mutliActionRunMode;
    
    // actions
    NSMutableArray *actions;
    NSMutableArray *actionsToRemove;
}

@property (nonatomic, assign) NSInteger multiActionRunMode;

- (id)initWithActionMode:(NSInteger)mode actions:(AXAction*)firstObject, ...;

@end
