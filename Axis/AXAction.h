//
//  AXAction.h
//  Axis
//
//  Created by Jethro Wilson on 25/04/2013.
//
//

#import <Foundation/Foundation.h>

#import "AXDataConstructs.h"
#import "AXPoint.h"

@interface AXAction : NSObject {
    // Action Settings
    NSInteger _type; // Transformation / Animation Type
    NSInteger _mode; // To / By
    CGFloat _duration;
    CGFloat _durationFrames;
    
    AXPoint _transformation;
}

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger mode;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat durationFrames;
@property (nonatomic, assign) AXPoint transformation;

- (id)initWithTransformationType:(NSInteger)newType transformationMode:(NSInteger)newMode transformation:(AXPoint)newTransformation duration:(CGFloat)newDuration;

- (void)setupActionWithType:(NSInteger)newType transformationMode:(NSInteger)newMode transformation:(AXPoint)newTransformation duration:(CGFloat)newDuration;

@end
