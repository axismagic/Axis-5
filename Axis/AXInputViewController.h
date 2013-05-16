//
//  AXInputViewControllerViewController.h
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AXInputViewController : UIViewController {
    BOOL _inputActive;
    
    NSMutableSet *_touchEvents;
    
    //
    
    NSMutableArray *interfaceObjects;
    
    CGFloat forwardMagnitude;
    CGFloat rightMagnitude;
    CGFloat leftMagnitude;
    BOOL fireMissile;
}

@property (nonatomic, assign) BOOL inputActive;

@property (nonatomic, retain) NSMutableSet *touchEvents;

//

@property (assign) CGFloat forwardMagnitude;
@property (assign) CGFloat rightMagnitude;
@property (assign) CGFloat leftMagnitude;
@property (assign) BOOL fireMissile;

- (void)touches:(NSSet*)touches withEvent:(UIEvent*)event;

//

//- (void)loadInterface;
//- (void)updateInterface;
//- (void)renderInterface;

- (CGRect)screenRectFromMeshRect:(CGRect)rect atPoint:(CGPoint)meshCenter;

- (void)clearEvents;
- (void)didReceiveMemoryWarning;
- (void)loadView;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)viewDidUnload;

- (void)dealloc;

@end
