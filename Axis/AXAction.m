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

- (id)initWithTransformationType:(NSInteger)newType transformationMode:(NSInteger)newMode transformation:(AXPoint)newTransformation duration:(CGFloat)newDuration {
    self = [super init];
    if (self != nil) {
        self.type = newType;
        self.mode = newMode;
        self.duration = newDuration;
        self.durationFrames = _duration * 60;
        
        self.transformation = newTransformation;
    }
    
    return self;
}

@end
