//
//  AXSceneObject.m
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXSceneObject.h"
#import "AXSceneController.h"
#import "AXInputViewController.h"
#import "AXMesh.h"

#pragma mark Spinny Square mesh
static CGFloat spinnySquareVertices[8] = {
    -0.5f, -0.5f,
    0.5f,  -0.5f,
    -0.5f,  0.5f,
    0.5f,   0.5f,
};

static CGFloat spinnySquareColors[16] = {
    1.0, 1.0,   0, 1.0,
    0,   1.0, 1.0, 1.0,
    0,     0,   0,   0,
    1.0,   0, 1.0, 1.0,
};

@implementation AXSceneObject

@synthesize translation, rotation, scale, active, mesh, meshBounds;

- (id)init {
    self = [super init];
    if (self != nil) {
        translation = AXPointMake(0.0, 0.0, 0.0);
        rotation = AXPointMake(0.0, 0.0, 0.0);
        scale = AXPointMake(1.0, 1.0, 1.0);
        
        meshBounds = CGRectZero;
        
        active = NO;
    }
    
    return self;
}

- (CGRect)meshBounds {
    if (CGRectEqualToRect(meshBounds, CGRectZero)) {
        meshBounds = [AXMesh meshBounds:mesh scale:scale];
    }
    
    return meshBounds;
}

- (void)awake {
    // called once when object is created
    mesh = [[AXMesh alloc] initWithVertexes:spinnySquareVertices
                                vertexCount:4
                                 vertexStride:2
                                renderStyle:GL_TRIANGLE_STRIP];
    mesh.colors = spinnySquareColors;
    mesh.colorStride = 4;
}

- (void)update {
    // overridden by subclasses
}

- (void)render {
    glPushMatrix();
    glLoadIdentity();
    
    // move to my position
    glTranslatef(translation.x, translation.y, translation.z);
    
    // rotate
    glRotatef(rotation.x, 1.0f, 0.0f, 0.0f);
    glRotatef(rotation.y, 0.0f, 1.0f, 0.0f);
    glRotatef(rotation.z, 0.0f, 0.0f, 1.0f);
    
    // scale
    glScalef(scale.x, scale.y, scale.z);
    
    [mesh render];
    
    // restore the matrix
    glPopMatrix();
}

- (void)dealloc {
    [super dealloc];
}

@end
