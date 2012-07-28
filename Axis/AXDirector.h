//
//  AXDirector.h
//  Axis
//
//  Created by Jethro Wilson on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AXInputViewController;
@class AXCollisionController;
@class AXSceneController;
@class EAGLView;

@interface AXDirector : NSObject {
    /*
     ***** removal?
     NSMutableDictionary *scenes;
    NSMutableDictionary *scenesToAdd;
    NSMutableDictionary *scenesToRemove;
    
    EAGLView *_openGLView;
    AXInputViewController *_inputController;*/
    
    // global access
    CGSize _viewSize;
}

/*@property (nonatomic, retain) EAGLView *openGLView;
@property (nonatomic, retain) AXInputViewController *inputController;*/

@property (nonatomic, assign) CGSize viewSize;

+ (AXDirector*)sharedDirector;
- (void)setupEngine;

@end
