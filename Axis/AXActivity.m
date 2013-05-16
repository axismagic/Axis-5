//
//  AXActivity.m
//  Axis
//
//  Created by Jethro Wilson on 25/04/2013.
//
//

#import "AXActivity.h"

@implementation AXActivity

@synthesize activated = _activated;
@synthesize activityCounter = _activityCounter, complete = _complete;
@synthesize startTransformation = _startTrasnformation;
@synthesize endTransformation = _endTransformation;
@synthesize delegate = _delegate;

- (id)init  {
    self = [super init];
    if (self != nil) {
        // action stuff
        self.type = 0;
        self.mode = 0;
        self.duration = 1;
        self.durationFrames = _duration * 60;
        
        self.transformation = AXPointMake(0, 0, 0);
        
        // activity stuff
        self.activated = NO;
        
        self.activityCounter = 0;
        self.complete = NO;
        
        self.startTransformation = AXPointMake(0, 0, 0);
        self.endTransformation = AXPointMake(0, 0, 0);
        
        self.delegate = nil;
        
    }
    return self;
}


- (id)initWithAction:(AXAction*)action {
    self = [super init];
    if (self != nil) {
        // setup self from action
        self.type = action.type;
        self.mode = action.mode;
        self.duration = action.duration;
        self.durationFrames = action.durationFrames;
        self.transformation = action.transformation;
        
        // activity stuff
        self.activated = NO;
        
        self.activityCounter = 0;
        self.complete = NO;
        
        self.startTransformation = AXPointMake(0, 0, 0);
        self.endTransformation = AXPointMake(0, 0, 0);
        
        self.delegate = nil;
    }
    
    return self;
}

#pragma mark activate

- (BOOL)activate {
    if (_delegate != nil) {
        // request start transformation
        self.startTransformation = [_delegate returnCurrentTrasnformationForType:_type];
        
        // work out end transformation
        if (_mode == AXACTransformBy) {
            // transform by adds transformation to start point
            self.endTransformation = AXPointAdd(_startTrasnformation, _transformation);
        } else if (_mode == AXACTransformTo) {
            // transform to transforms regardless of start point
            self.endTransformation = _transformation;
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

#pragma mark - Frame Transformation

- (void)makeFrameTransformation {
    if (_activated && !_complete) {
        if (_type == AXACDelay) {
            // do nothing, only increase counter
            self.activityCounter++;
            if (_activityCounter >= _durationFrames)
                self.complete = YES;
            
            return;
        }
        
        // get transformation for duration (might be different to _transformation due to _mode
        AXPoint durationTransformation = AXPointSubtract(_endTransformation, _startTrasnformation);
        // get frame transformation
        AXPoint frameTransformation = AXPointMake(durationTransformation.x / _durationFrames, durationTransformation.y / _durationFrames, durationTransformation.z / _durationFrames);
        
        [_delegate updateWithTransformation:frameTransformation type:_type];
        
        // increase counter
        // counter increases at end so if complete, activity does not run again
        self.activityCounter++;
        if (_activityCounter >= _durationFrames)
            self.complete = YES;
    }
}

@end
