//
//  AXAction.h
//  Axis
//
//  Created by Jethro Wilson on 21/04/2013.
//
//

#import <Foundation/Foundation.h>

#import "AXPoint.h"

enum eActions {
    kATmovement = 1,
    kATscale = 2,
    kATrotation = 3
    // Animations?
};

enum eActionsToBy {
    kActionEffectTo = 1, // moves/etc. to given point
    kActionEffectBy = 2 // moves/etc. by given point
};

@class AXObject;

@protocol AXActionProtocol <NSObject>
/* Used to ask objects directly for the startEffect */

- (AXPoint)requestCurrentActionStateForMode:(CGFloat)mode;
- (void)updateState:(CGFloat)state withEffect:(AXPoint)effect;

@end

@interface AXAction : NSObject {
    // delegate
    AXObject <AXActionProtocol> *_objectDelegate;
    
    // Action Details
    CGFloat _actionType;
    CGFloat _actionMode;
    CGFloat _actionDuration; // ***** in seconds, needs to allow for point mode
    BOOL _actionReady; // action is not ready until attached to an object - this gives it the start point and allows it to work out perFramePoint
    
    // Action Completion Flags
    CGFloat _actionFinishedCounter;
    BOOL _actionComplete;
    
    // Action Details
    AXPoint _desiredEffect; // passed in
    AXPoint _startEffect; // start effect
    AXPoint _endEffect; // end desired effect
}

@property (nonatomic, retain) AXObject <AXActionProtocol> *objectDelegate;

@property (nonatomic, assign) CGFloat actionType;
@property (nonatomic, assign) CGFloat actionMode;
@property (nonatomic, assign) CGFloat actionDuration;
@property (nonatomic, assign) BOOL actionReady;

@property (nonatomic, assign) CGFloat actionFinishedCounter;
@property (nonatomic, assign) BOOL actionComplete;

@property (nonatomic, assign) AXPoint desiredEffect;
@property (nonatomic, assign) AXPoint startEffect;
@property (nonatomic, assign) AXPoint endEffect;

- (void)setupActionWithType:(CGFloat)type mode:(CGFloat)mode effect:(AXPoint)effect duration:(CGFloat)duration;
- (void)activateAction;
- (void)activateAction:(AXPoint)startEffect; // *R*
- (void)getActionFrameEffect;

@end