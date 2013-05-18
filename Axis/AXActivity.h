//
//  AXActivity.h
//  Axis
//
//  Created by Jethro Wilson on 25/04/2013.
//
//

#import "AXAction.h"

@class AXObject;

@protocol AXActivityProtocol <NSObject>

- (AXPoint)returnCurrentTrasnformationForType:(NSInteger)type;
- (void)updateWithTransformation:(AXPoint)transformationUpdate type:(NSInteger)type;

@end

@interface AXActivity : AXAction {
    // Activity Ready
    BOOL _activated;
    
    // Activity Completion
    CGFloat _activityCounter;
    BOOL _complete;
    
    // details
    AXPoint _startTransformation;
    AXPoint _endTransformation;
    
    // delegate
    AXObject <AXActivityProtocol> *_delegate;
}

@property (nonatomic, assign) BOOL activated;

@property (nonatomic, assign) CGFloat activityCounter;
@property (nonatomic, assign) BOOL complete;

@property (nonatomic, assign) AXPoint startTransformation;
@property (nonatomic, assign) AXPoint endTransformation;

@property (nonatomic, retain) AXObject <AXActivityProtocol> *delegate;

- (id)initWithAction:(AXAction*)action;
- (BOOL)activate;
- (void)makeFrameTransformation;

@end
