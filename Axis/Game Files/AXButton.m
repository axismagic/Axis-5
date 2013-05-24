//
//  AXButton.m
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXButton.h"

#pragma mark square
static NSInteger BBSquareVertexStride = 2;
static NSInteger BBSquareColorStride = 4;
static GLenum BBSquareOutlineRenderStyle = GL_LINE_LOOP;
static NSInteger BBSquareOutlineVertexesCount = 4;
static CGFloat BBSquareOutlineVertexes[8] = {-0.5f, -0.5f, 0.5f,  -0.5f, 0.5f,   0.5f, -0.5f,  0.5f};
static CGFloat BBSquareOutlineColorValues[16] = {1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0};
static GLenum BBSquareFillRenderStyle = GL_TRIANGLE_STRIP;
static NSInteger BBSquareFillVertexesCount = 4;
static CGFloat BBSquareFillVertexes[8] = {-0.5,-0.5, 0.5,-0.5, -0.5,0.5, 0.5,0.5};

@implementation AXButton

@synthesize target, buttonDownAction, buttonUpAction;

- (void)awake {
    pressed = NO;
    self.mesh = [[AXMesh alloc] initWithVertexes:BBSquareOutlineVertexes
                                vertexCount:BBSquareOutlineVertexesCount
                                 vertexStride:BBSquareVertexStride
                                renderStyle:BBSquareOutlineRenderStyle];
    _mesh.colors = BBSquareOutlineColorValues;
    _mesh.colorStride = BBSquareColorStride;
    
    screenRect = [[AXDirector sharedDirector].inputController screenRectFromMeshRect:self.meshBounds atPoint:CGPointMake(_location.x, _location.y)];
    [self setNotPressedVertexes];
}

/* *R?*- (void)update {
    [self handleTouches];
    [super update];
}*/

- (void)beginUpdate {
    [self handleTouches];
}

- (void)handleTouches {
   /* NSSet *touches = [[AXDirector sharedDirector].inputController touchEvents];
    // if no touches, return now
    if ([touches count] == 0)
        return;
    
    BOOL pointInBounds = NO;
    for (UITouch *touch in [touches allObjects]) {
        CGPoint touchPoint = [touch locationInView:[touch view]];
        if (CGRectContainsPoint(screenRect, touchPoint)) {
            pointInBounds = YES;
            if (touch.phase != UITouchPhaseEnded) [self touchDown];
        }
    }
    
    if (!pointInBounds)
        [self touchUp];*/
}

- (void)touchUp {
    if (!pressed)
        return;
    pressed = NO;
    [self setNotPressedVertexes];
    [target performSelector:buttonUpAction];
}

- (void)touchDown {
    if (pressed)
        return;
    pressed = YES;
    [self setPressedVertexes];
    [target performSelector:buttonDownAction];
}

- (void)setPressedVertexes {
    self.mesh.vertexes = BBSquareFillVertexes;
    self.mesh.renderStyle = BBSquareFillRenderStyle;
    self.mesh.vertexCount = BBSquareFillVertexesCount;
    self.mesh.colors = BBSquareOutlineColorValues;
}

- (void)setNotPressedVertexes {
    self.mesh.vertexes = BBSquareOutlineVertexes;
    self.mesh.renderStyle = BBSquareOutlineRenderStyle;
    self.mesh.vertexCount = BBSquareOutlineVertexesCount;
    self.mesh.colors = BBSquareOutlineColorValues;
}

@end
