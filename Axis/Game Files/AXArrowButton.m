//
//  AXArrowButton.m
//  Axis
//
//  Created by Jethro Wilson on 27/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXArrowButton.h"

#pragma mark arrow button mesh
static NSInteger BBArrowButtonOutlineVertexesCount = 14;
static CGFloat BBArrowButtonOutlineVertexes[28] = {-0.25, 0.0, 0.25, 0.0,
    0.25, 0.0, 0.1, 0.25,0.25, 0.0, 0.1,-0.25, -0.5,-0.5,-0.5, 0.5, -0.5, 0.5, 
    0.5, 0.5, 0.5, 0.5, 0.5,-0.5, 0.5,-0.5,-0.5,-0.5};
static GLenum BBArrowButtonOutlineRenderStyle = GL_LINES;
static CGFloat BBArrowButtonOutlineColorValues[56] = 
{1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0,
    1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0,
    1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0,
    1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0};

@implementation AXArrowButton

- (void)setNotPressedVertexes {
    self.mesh.vertexes = BBArrowButtonOutlineVertexes;
    self.mesh.vertexCount = BBArrowButtonOutlineVertexesCount;
    self.mesh.renderStyle = BBArrowButtonOutlineRenderStyle;
    self.mesh.colors = BBArrowButtonOutlineColorValues;
}

@end
