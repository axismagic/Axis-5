//
//  AXInputViewControllerViewController.m
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXInputViewController.h"

#import "AXButton.h"

@implementation AXInputViewController

@synthesize touchEvents;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // initialise touch storage set
        touchEvents = [[NSMutableSet alloc] init];
    }
    
    return self;
}

#pragma mark Interface

- (void)loadInterface {
    if (interfaceObjects == nil)
        interfaceObjects = [[NSMutableArray alloc] init];
    
    // right arrow button
    AXButton *rightButton = [[AXButton alloc] init];
    rightButton.scale = AXPointMake(50.0, 50.0, 1.0);
    rightButton.translation = AXPointMake(-155.0, -130.0, 0.0);
    rightButton.active = YES;
    [rightButton awake];
    [interfaceObjects addObject:rightButton];
    [rightButton release];
    
    // left arrow button
    AXButton *leftButton = [[AXButton alloc] init];
    leftButton.scale = AXPointMake(50.0, 50.0, 1.0);
    leftButton.translation = AXPointMake(-210.0, -130.0, 0.0);
    leftButton.active = YES;
    [leftButton awake];
    [interfaceObjects addObject:leftButton];
    [leftButton release];
    
    // right arrow button
    AXButton *forwardButton = [[AXButton alloc] init];
    forwardButton.scale = AXPointMake(50.0, 50.0, 1.0);
    forwardButton.translation = AXPointMake(-185.0, -75.0, 0.0);
    forwardButton.active = YES;
    [forwardButton awake];
    [interfaceObjects addObject:forwardButton];
    [forwardButton release];
    
    // right arrow button
    AXButton *fireButton = [[AXButton alloc] init];
    fireButton.scale = AXPointMake(50.0, 50.0, 1.0);
    fireButton.translation = AXPointMake(210.0, -130.0, 0.0);
    rightButton.active = YES;
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
    screenCenter.x = meshCenter.y + 160.0;
    screenCenter.y = meshCenter.x + 240.0;
    
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
