//
//  AXAction.m
//  Axis
//
//  Created by Jethro Wilson on 25/04/2013.
//
//

#import "AXAction.h"

@implementation AXAction

@synthesize type = _type, mode = _mode, duration = _duration, durationFrames = _durationFrames;
@synthesize transformation = _transformation;

- (id)init {
    self = [super init];
    if (self != nil) {
        _type = 0;
        _mode = 0;
        _duration = 1;
        _durationFrames = _duration * 60;
        
        _transformation = AXPointMake(0, 0, 0);
    }
    
    return self;
}

- (id)initWithTransformationType:(NSInteger)newType transformationMode:(NSInteger)newMode transformation:(AXPoint)newTransformation duration:(CGFloat)newDuration {
    self = [super init];
    if (self != nil) {
        /*self.type = newType;
        self.mode = newMode;
        self.duration = newDuration;
        self.durationFrames = _duration * 60;
        
        self.transformation = newTransformation;*/
        // setup self
        [self init];
        [self setupActionWithType:newType transformationMode:newMode transformation:newTransformation duration:newDuration];
    }
    
    return self;
}

- (void)setupActionWithType:(NSInteger)newType transformationMode:(NSInteger)newMode transformation:(AXPoint)newTransformation duration:(CGFloat)newDuration {
    self.type = newType;
    self.mode = newMode;
    self.duration = newDuration;
    self.durationFrames = _duration * 60;
    
    self.transformation = newTransformation;
}

@end
