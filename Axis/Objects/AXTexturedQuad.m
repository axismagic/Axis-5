//
//  AXTexturedQuad.m
//  Axis
//
//  Created by Jethro Wilson on 01/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXTexturedQuad.h"

/*static CGFloat AXTexturedQuadVertexes[8] = {-0.5,-0.5, 0.5,-0.5, -0.5,0.5, 0.5,0.5};
static CGFloat AXTexturedQuadColorValues[16] = {1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0};*/

static CGFloat BBTexturedQuadVertexes[8] = {-0.5,-0.5, 0.5,-0.5, -0.5,0.5, 0.5,0.5};
static CGFloat BBTexturedQuadColorValues[16] = {1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0};

@implementation AXTexturedQuad

@synthesize uvCoordinates, materialKey;

- (id)initWithVertexes:(CGFloat*)newVertexes {
    self = [super initWithVertexes:newVertexes vertexCount:4 vertexStride:2 renderStyle:GL_TRIANGLE_STRIP];
    if (self != nil) {
        // 4 vertexes
        uvCoordinates = (CGFloat*) malloc(8 * sizeof(CGFloat));
        colors = BBTexturedQuadColorValues;
        colorStride = 4;
    }
    
    return self;
}

- (id)init {
    self = [super initWithVertexes:BBTexturedQuadVertexes vertexCount:4 vertexStride:2 renderStyle:GL_TRIANGLE_STRIP];
    if (self != nil) {
        // 4 vertexes
        uvCoordinates = (CGFloat*) malloc(8 * sizeof(CGFloat));
        colors = BBTexturedQuadColorValues;
        colorStride = 4;
    }
    
    return self;
}

- (void)render {
    glVertexPointer(vertexStride, GL_FLOAT, 0, vertexes);
    glEnableClientState(GL_VERTEX_ARRAY);
    glColorPointer(colorStride, GL_FLOAT, 0, colors);
    glEnableClientState(GL_COLOR_ARRAY);
    
    if (materialKey != nil) {
        [[AXMaterialController sharedMaterialController] bindMaterial:materialKey];
        
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        glTexCoordPointer(2, GL_FLOAT, 0, uvCoordinates);
    }
    
    // render
    glDrawArrays(renderStyle, 0, vertexCount);
}

- (void)dealloc {
    free(uvCoordinates);
    [super dealloc];
}

@end
