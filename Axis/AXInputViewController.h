//
//  AXInputViewControllerViewController.h
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AXInputViewController : UIViewController {
    NSMutableSet *touchEvents;
    
    NSMutableArray *interfaceObjects;
}

@property (retain) NSMutableSet *touchEvents;

- (void)loadInterface;
- (void)updateInterface;
- (void)renderInterface;

- (CGRect)screenRectFromMeshRect:(CGRect)rect atPoint:(CGPoint)meshCenter;

- (BOOL)touchesDidBegin;
- (void)clearEvents;
- (void)didReceiveMemoryWarning;
- (void)loadView;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)viewDidUnload;

- (void)dealloc;

@end
