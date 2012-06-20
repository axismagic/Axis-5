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

@synthesize x, y, z, xRotation, yRotation, zRotation, xScale, yScale, zScale, active;

- (id)init {
    self = [super init];
    if (self != nil) {
        x = 0.0;
        y = 0.0;
        z = 0.0;
        
        xRotation = 0.0;
        yRotation = 0.0;
        zRotation = 0.0;
        
        xScale = 1.0;
        yScale = 1.0;
        zScale = 1.0;
        
        active = NO;
    }
    
    return self;
}

- (void)awake {
    // called once when object is created
    mesh = [[AXMesh alloc] initWithVertexes:spinnySquareVertices
                                vertexCount:4
                                 vertexSize:2
                                renderStyle:GL_TRIANGLE_STRIP];
    mesh.colors = spinnySquareColors;
    mesh.colorSize = 4;
}

- (void)update {
    // called once every frame
    NSSet *touches = [[AXSceneController sharedSceneController].inputController touchEvents];
    for (UITouch *touch in [touches allObjects]) {
        if (touch.phase == UITouchPhaseEnded) {
            active = !active;
        }
    }
    
    if (active) zRotation += 3.0;
}

- (void)render {
    glPushMatrix();
    glLoadIdentity();
    
    // move to my position
    glTranslatef(x, y, z);
    
    // rotate
    glRotatef(xRotation, 1.0f, 0.0f, 0.0f);
    glRotatef(yRotation, 0.0f, 1.0f, 0.0f);
    glRotatef(zRotation, 0.0f, 0.0f, 1.0f);
    
    // scale
    glScalef(xScale, yScale, zScale);
    
    [mesh render];
    
    // restore the matrix
    glPopMatrix();
}

- (void)dealloc {
    [super dealloc];
}

@end
