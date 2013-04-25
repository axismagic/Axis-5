//
//  AXAction.m
//  Axis
//
//  Created by Jethro Wilson on 21/04/2013.
//
//

#import "AXAction.h"

@implementation AXAction

@synthesize objectDelegate = _objectDelegate;
@synthesize actionType = _actionType, actionMode = _actionMode, actionDuration = _actionDuration, actionReady = _actionReady;
@synthesize actionFinishedCounter = _actionFinishedCounter, actionComplete = _actionComplete;
@synthesize desiredEffect = _desiredEffect, startEffect = _startEffect, endEffect = _endEffect;

- (void)dealloc {
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self != nil) {
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

- (void)setupActionWithType:(CGFloat)type mode:(CGFloat)mode effect:(AXPoint)effect duration:(CGFloat)duration {
    self.actionType = type;
    self.actionMode = mode;
    self.actionDuration = duration;
    self.desiredEffect = effect;
    
    NSAssert(_actionDuration != 0, @"Action duration must not be 0");

}

- (void)activateAction {
    // request start effect
    if (_objectDelegate != nil) {
        self.startEffect = [_objectDelegate requestCurrentActionStateForMode:_actionMode];
        
        // work out end position
        if (_actionMode == kActionEffectBy) {
            // actionEffectBy - adds desired effect to start point
            self.endEffect = AXPointMake(_startEffect.x + _desiredEffect.x, _startEffect.y + _desiredEffect.y, _startEffect.z + _desiredEffect.z);
        } else if (_actionMode == kActionEffectTo) {
            // actionEffectTo - moves to desired effect regardless of start point
            self.endEffect = _desiredEffect;
        }
        
        self.actionReady = YES;

    } else {
        self.actionReady = NO;
        NSLog(@"Action Failed to obtain parent's start effect");
    }
}

- (void)activateAction:(AXPoint)startEffect {
    self.startEffect = startEffect;
    
    if (_actionMode == kActionEffectBy) {
        // actionEffectBy - adds desired effect to start point
        self.endEffect = AXPointMake(_startEffect.x + _desiredEffect.x, _startEffect.y + _desiredEffect.y, _startEffect.z + _desiredEffect.z);
    } else if (_actionMode == kActionEffectTo) {
        // actionEffectTo - moves to desired effect regardless of start point
        self.endEffect = _desiredEffect;
    }
    
    // action is ready for use
    self.actionReady = YES;
}

- (void)getActionFrameEffect {
    if (_actionReady) {
        if (_actionComplete) {
            NSLog(@"Action Complete, needs removal");
            return;
        }
        
        // use start, end and duration to work out per frame movement. Will support easing.
        AXPoint secondsEffect = AXPointSubtract(_endEffect, _startEffect);
        
        AXPoint frameEffect = AXPointMake(secondsEffect.x / (_actionDuration * 60), secondsEffect.y / (_actionDuration * 60), secondsEffect.z / (_actionDuration * 60));
        
        self.actionFinishedCounter++;
        if (_actionFinishedCounter == _actionDuration *60)
            self.actionComplete = YES;
        
        [_objectDelegate updateState:_actionMode withEffect:frameEffect];
    } else
        NSLog(@"Action Not Ready");
}

@end
