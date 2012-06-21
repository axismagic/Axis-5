//
//  AXMesh.m
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXMesh.h"

@implementation AXMesh

@synthesize vertexCount, vertexStride, colorStride, renderStyle, vertexes, colors;

- (id)initWithVertexes:(CGFloat *)verts
           vertexCount:(NSInteger)vertCount
            vertexStride:(NSInteger)vertStride
           renderStyle:(GLenum)style {
    
    self = [super init];
    if (self != nil) {
        self.vertexes = verts;
        self.vertexCount = vertCount;
        self.vertexStride = vertStride;
        self.renderStyle = style;
    }
    return self;
}

+ (CGRect)meshBounds:(AXMesh*)mesh scale:(AXPoint)scale {
    if (mesh == nil)
        return CGRectZero;
    // find extremes of vertexes
    if (mesh.vertexCount < 2)
        return CGRectZero;
    CGFloat xMin, yMin, xMax, yMax;
    xMin = xMax = mesh.vertexes[0];
    yMin = yMax = mesh.vertexes[1];
    NSInteger index;
    for (index = 0; index < mesh.vertexCount; index++) {
        NSInteger position = index * mesh.vertexStride;
        if (xMin > mesh.vertexes[position] * scale.x)
            xMin = mesh.vertexes[position] * scale.x;
        if (xMax < mesh.vertexes[position] * scale.x)
            xMax = mesh.vertexes[position] * scale.x;
        if (yMin > mesh.vertexes[position + 1] * scale.y)
            yMin = mesh.vertexes[position + 1] * scale.y;
        if (yMax < mesh.vertexes[position + 1] * scale.y)
            yMax = mesh.vertexes[position + 1] * scale.y;
    }
    CGRect meshBounds = CGRectMake(xMin, yMin, xMax - xMin, yMax - yMin);
    if (CGRectGetWidth(meshBounds) < 1.0)
        meshBounds.size.width = 1.0;
    if (CGRectGetHeight(meshBounds) < 1.0)
        meshBounds.size.height = 1.0;
    
    return meshBounds;
}

- (void)render {
    glVertexPointer(vertexStride, GL_FLOAT, 0, vertexes);
    glEnableClientState(GL_VERTEX_ARRAY);
    glColorPointer(colorStride, GL_FLOAT, 0, colors);
    glEnableClientState(GL_COLOR_ARRAY);
    
    // render
    glDrawArrays(renderStyle, 0, vertexCount);
}

- (void)dealloc {
    [super dealloc];
}

@end
