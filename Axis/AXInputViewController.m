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

@synthesize touchEvents;
@synthesize forwardMagnitude, leftMagnitude, rightMagnitude, fireMissile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // initialise touch storage set
        touchEvents = [[NSMutableSet alloc] init];
        forwardMagnitude = 0.0;
        leftMagnitude = 0.0;
        rightMagnitude = 0.0;
    }
    
    return self;
}

- (void)loadView {
    
}

#pragma mark Interface

- (void)loadInterface {
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
}

- (CGRect)screenRectFromMeshRect:(CGRect)rect atPoint:(CGPoint)meshCenter {
    CGPoint screenCenter = CGPointZero;
    CGPoint rectOrigin = CGPointZero;
    // since view is rotated, x and y are flipped
    // *****
    CGFloat vWidth = [AXSceneController sharedSceneController].viewSize.width;
    CGFloat vHeight = [AXSceneController sharedSceneController].viewSize.height;
    
    screenCenter.x = meshCenter.y + vWidth/2;
    screenCenter.y = meshCenter.x + vHeight/2;
    
    rectOrigin.x = screenCenter.x - (CGRectGetHeight(rect)/2.0);
    rectOrigin.y = screenCenter.y - (CGRectGetWidth(rect)/2.0);
    
    return CGRectMake(rectOrigin.x, rectOrigin.y, CGRectGetHeight(rect), CGRectGetWidth(rect));
}

#pragma mark Touch Event Handlers

- (void)clearEvents {
    [touchEvents removeAllObjects];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [touchEvents addObjectsFromArray:[touches allObjects]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [touchEvents addObjectsFromArray:[touches allObjects]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [touchEvents addObjectsFromArray:[touches allObjects]];
}

#pragma mark Input Registers

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
