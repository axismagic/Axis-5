//
//  AXInputViewControllerViewController.m
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXInputViewController.h"

#import "AXButton.h"
#import "AXArrowButton.h"
#import "AXTexturedButton.h"

@implementation AXInputViewController

@synthesize inputActive = _inputActive;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // initialise touch storage set
    }
    
    return self;
}

- (void)loadView {
    
}

- (CGRect)screenRectFromMeshRect:(CGRect)rect atPoint:(CGPoint)meshCenter {
    CGPoint screenCenter = CGPointZero;
    CGPoint rectOrigin = CGPointZero;
    // since view is rotated, x and y are flipped
    // *****
    CGFloat vWidth = [AXDirector sharedDirector].viewSize.width;
    CGFloat vHeight = [AXDirector sharedDirector].viewSize.height;
    
    screenCenter.x = meshCenter.y + vWidth/2;
    screenCenter.y = meshCenter.x + vHeight/2;
    
    rectOrigin.x = screenCenter.x - (CGRectGetHeight(rect)/2.0);
    rectOrigin.y = screenCenter.y - (CGRectGetWidth(rect)/2.0);
    
    return CGRectMake(rectOrigin.x, rectOrigin.y, CGRectGetHeight(rect), CGRectGetWidth(rect));
}

#pragma mark - Object Registration

- (void)registerObjectForTouches:(AXObject*)object {
    if (_registeredObjects == nil)
        _registeredObjects = [[NSMutableSet alloc] init];
    
    [_registeredObjects addObject:object];
}

- (void)unregisterObjectForTouches:(AXObject*)object {
    if ([_registeredObjects containsObject:object])
        [_registeredObjects removeObject:object];
}

#pragma mark Touch Event Handlers

- (void)touches:(NSSet *)touches withEvent:(UIEvent *)event {
    // Store touches
    // ***** Store the touches
    
    /*for (UITouch *touch in [touches allObjects]) {
        @autoreleasepool {
            // setup
            double now = CACurrentMediaTime();
            CGSize yCorrector = [[AXDirector sharedDirector] viewSize];
            
            // convert UITouch to AXTouch
            for (UITouch *uiTouch in [touches allObjects]) {
                AXTouch *touch = [AXTouch touch];
                CGPoint location = [uiTouch locationInView:self.view];
                CGPoint previousLocation = [uiTouch previousLocationInView:self.view];
                // add new properties
                touch.timeStamp = now;
                touch.currentPoint = CGPointMake(location.x, yCorrector.height - location.y);
                touch.previousPoint = CGPointMake(previousLocation.x, yCorrector.height - previousLocation.y);
                touch.tapCount = uiTouch.tapCount;
                touch.phase = (AXTouchPhase)uiTouch.phase;
                
                [_touchEvents addObject:touch];
            }
        }
    }*/
    
    // **** temporary
    //[_touchEvents addObjectsFromArray:[touches allObjects]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //[self touches:touches withEvent:event];
    for (AXObject *obj in _registeredObjects) {
        if ([obj respondsToSelector:@selector(axTouchesBegan:withEvent:)]) {
            [obj axTouchesBegan:touches withEvent:event];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //[self touches:touches withEvent:event];
    for (AXObject *obj in _registeredObjects) {
        if ([obj respondsToSelector:@selector(axTouchesMoved:withEvent:)]) {
            [obj axTouchesMoved:touches withEvent:event];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //[self touches:touches withEvent:event];
    for (AXObject *obj in _registeredObjects) {
        if ([obj respondsToSelector:@selector(axTouchesEnded:withEvent:)]) {
            [obj axTouchesEnded:touches withEvent:event];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    //[self touches:touches withEvent:event];
    for (AXObject *obj in _registeredObjects) {
        if ([obj respondsToSelector:@selector(axTouchesCancelled:withEvent:)]) {
            [obj axTouchesCancelled:touches withEvent:event];
        }
    }
}

- (void)clearEvents {
    //[self.touchEvents removeAllObjects];
}


#pragma mark Unload, Dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc {
    [super dealloc];
}

@end
