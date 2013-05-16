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

#import "AXTouch.h"

@implementation AXInputViewController

@synthesize inputActive = _inputActive;

@synthesize forwardMagnitude, leftMagnitude, rightMagnitude, fireMissile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // initialise touch storage set
    }
    
    return self;
}

- (void)loadView {
    
}

#pragma mark Interface

/*- (void)loadInterface {
    if (interfaceObjects == nil)
        interfaceObjects = [[NSMutableArray alloc] init];
    
    // right arrow button
    // OLD AXButton *rightButton = [[AXArrowButton alloc] init];
    AXTexturedButton *rightButton = [[AXTexturedButton alloc] initWithUpKey:@"rightUp" downKey:@"rightDown"];
    rightButton.scale = AXPointMake(50.0, 50.0, 1.0);
    rightButton.translation = AXPointMake(-155.0, -130.0, 0.0);
    // set actions
    rightButton.target = self;
    rightButton.buttonDownAction = @selector(rightButtonDown);
    rightButton.buttonUpAction = @selector(rightButtonUp);
    // activate
    rightButton.active = YES;
    [rightButton awake];
    [interfaceObjects addObject:rightButton];
    [rightButton release];
    
    // left arrow button
    // OLD AXButton *leftButton = [[AXArrowButton alloc] init];
    AXTexturedButton *leftButton = [[AXTexturedButton alloc] initWithUpKey:@"leftUp" downKey:@"leftDown"];
    leftButton.scale = AXPointMake(50.0, 50.0, 1.0);
    leftButton.translation = AXPointMake(-210.0, -130.0, 0.0);
    //leftButton.rotation = AXPointMake(0.0, 0.0, 180.0);
    // set actions
    leftButton.target = self;
    leftButton.buttonDownAction = @selector(leftButtonDown);
    leftButton.buttonUpAction = @selector(leftButtonUp);
    // activate
    leftButton.active = YES;
    [leftButton awake];
    [interfaceObjects addObject:leftButton];
    [leftButton release];
    
    // forward arrow button
    // OLD AXButton *forwardButton = [[AXArrowButton alloc] init];
    AXTexturedButton *forwardButton = [[AXTexturedButton alloc] initWithUpKey:@"thrustUp" downKey:@"thrustDown"];
    forwardButton.scale = AXPointMake(50.0, 50.0, 1.0);
    forwardButton.translation = AXPointMake(-185.0, -75.0, 0.0);
    //forwardButton.rotation = AXPointMake(0.0, 0.0, 90.0);
    // set actions
    forwardButton.target = self;
    forwardButton.buttonDownAction = @selector(forwardButtonDown);
    forwardButton.buttonUpAction = @selector(forwardButtonUp);
    // activate
    forwardButton.active = YES;
    [forwardButton awake];
    [interfaceObjects addObject:forwardButton];
    [forwardButton release];
    
    // fire arrow button
    // OLD AXButton *fireButton = [[AXButton alloc] init];
    AXTexturedButton *fireButton = [[AXTexturedButton alloc] initWithUpKey:@"fireUp" downKey:@"fireDown"];
    fireButton.scale = AXPointMake(50.0, 50.0, 1.0);
    fireButton.translation = AXPointMake(210.0, -130.0, 0.0);
    // set actions
    fireButton.target = self;
    fireButton.buttonDownAction = @selector(fireButtonDown);
    fireButton.buttonUpAction = @selector(fireButtonUp);
    // activate
    fireButton.active = YES;
    [fireButton awake];
    [interfaceObjects addObject:fireButton];
    [fireButton release];
}

- (void)updateInterface {
    [interfaceObjects makeObjectsPerformSelector:@selector(update)];
}

- (void)renderInterface {
    [interfaceObjects makeObjectsPerformSelector:@selector(render)];
}*/

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
    
    for (UITouch *touch in [touches allObjects]) {
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
    }
    
    /*if (!self.paused && _lastTouchTimestamp != event.timestamp)
    {
        @autoreleasepool
        {
            CGSize viewSize = self.view.bounds.size;
            float xConversion = _stage.width / viewSize.width;
            float yConversion = _stage.height / viewSize.height;
            
            // convert to SPTouches and forward to stage
            NSMutableSet *touches = [NSMutableSet set];
            double now = CACurrentMediaTime();
            for (UITouch *uiTouch in [event touchesForView:self.view])
            {
                CGPoint location = [uiTouch locationInView:self.view];
                CGPoint previousLocation = [uiTouch previousLocationInView:self.view];
                SPTouch *touch = [SPTouch touch];
                touch.timestamp = now; // timestamp of uiTouch not compatible to Sparrow timestamp
                touch.globalX = location.x * xConversion;
                touch.globalY = location.y * yConversion;
                touch.previousGlobalX = previousLocation.x * xConversion;
                touch.previousGlobalY = previousLocation.y * yConversion;
                touch.tapCount = uiTouch.tapCount;
                touch.phase = (SPTouchPhase)uiTouch.phase;
                [touches addObject:touch];
            }
            [_touchProcessor processTouches:touches];
            _lastTouchTimestamp = event.timestamp;
        }
    }*/
    
    // temporary
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

/*- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_touchEvents addObjectsFromArray:[touches allObjects]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [_touchEvents addObjectsFromArray:[touches allObjects]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_touchEvents addObjectsFromArray:[touches allObjects]];
}*/

/*#pragma mark Input Registers

- (void)fireButtonDown {
    self.fireMissile = YES;
}

- (void)fireButtonUp {
}

- (void)leftButtonDown {
    self.leftMagnitude = 1.0;
}

- (void)leftButtonUp {
    self.leftMagnitude = 0.0;
}

- (void)rightButtonDown {
    self.rightMagnitude = 1.0;
}

- (void)rightButtonUp {
    self.rightMagnitude = 0.0;
}

- (void)forwardButtonDown {
    self.forwardMagnitude = 1.0;
}

- (void)forwardButtonUp {
    self.forwardMagnitude = 0.0;
}*/


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
