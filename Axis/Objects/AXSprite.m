//
//  AXSceneObject.m
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXSprite.h"
#import "AXSceneController.h"
#import "AXInputViewController.h"
#import "AXCollider.h"

/* #pragma mark Spinny Square mesh
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
}; */

@implementation AXSprite

@synthesize translation, rotation, scale, active, mesh, meshBounds, matrix, collider;
@synthesize hasChildren, isChild;
@synthesize worldPosition, vectorFromParent;
@synthesize delegate = _delegate;

- (id)init {
    self = [super init];
    if (self != nil) {
        worldPosition = AXPointMake(0.0, 0.0, 0.0);
        vectorFromParent = AXPointMake(0.0, 0.0, 0.0);
        
        translation = AXPointMake(0.0, 0.0, 0.0);
        rotation = AXPointMake(0.0, 0.0, 0.0);
        scale = AXPointMake(1.0, 1.0, 1.0);
        
        matrix = (CGFloat*) malloc(16 * sizeof(CGFloat));
        self.collider = nil;
        
        meshBounds = CGRectZero;
        
        hasChildren = NO;
        isChild = NO;
        
        active = NO;
        
        self.delegate = nil;
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
    // overridden
}

//- (void)awake {
    /*// called once when object is created
    mesh = [[AXMesh alloc] initWithVertexes:spinnySquareVertices
                                vertexCount:4
                                 vertexStride:2
                                renderStyle:GL_TRIANGLE_STRIP];
    mesh.colors = spinnySquareColors;
    mesh.colorStride = 4;*/
//}

- (void)addChild:(AXSprite *)child {
    // initialise children array
    if (children == nil)
        children = [[NSMutableArray alloc] init];
    
    // if child is not already a child, add new child.
    if (!child.isChild) {
        // set child
        child.active = YES;
        [child awake];
        
        // add as child
        child.isChild = YES;
        [children addObject:child];
        
        // set child delegate
        child.delegate = _delegate;
        
        [child finalAwake];
        
        // if has no children already, set yes
        if (!hasChildren)
            hasChildren = YES;
    } else
        return;
}

// ***** method for removing children required

- (void)update {
    // update self, used in subclasses
    [self updateBeginningPhase];
    
    // work out relative position of children (offset)
    if (hasChildren) {
        // loop through children and work out relative position
        for (AXSprite *child in children) {
            // work out relative position
            AXPoint childRelativePosition = AXPointMake(child.translation.x - self.translation.x,
                                                        child.translation.y - self.translation.y,
                                                        child.translation.z - self.translation.z);
            // give child new relative position
            child.vectorFromParent = childRelativePosition;
        }
    }
    
    // update self, used in subclasses
    [self updateMiddlePhase];
    
    // update openGL on self
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
    
    // save matrix
    glGetFloatv(GL_MODELVIEW_MATRIX, matrix);
    // restore matrix
    glPopMatrix();
    
    // update collider
    if (collider != nil)
        [collider updateCollider:self];
    
    if (hasChildren) {
        // update children positions
        for (AXSprite *child in children) {
            // tell child of new position
            AXPoint childNewPosition = AXPointMake(self.translation.x + child.vectorFromParent.x,
                                                   self.translation.y + child.vectorFromParent.y,
                                                   self.translation.z + child.vectorFromParent.z);
            
            child.translation = childNewPosition;
        }
        
        // update all children
        [children makeObjectsPerformSelector:@selector(update)];
    }
    
    // update self, used in subclasses
    [self updateEndPhase];
}

- (void)updateBeginningPhase {
    
}

- (void)updateMiddlePhase {
    
}

- (void)updateEndPhase {
    
}

- (void)render {
    // if not active, do not render self or children
    if (!active)
        return;
    
    // render children
    if (hasChildren && !AX_ENABLE_RENDER_CHILDREN_ABOVE) {
        [children makeObjectsPerformSelector:@selector(render)];
    }
    
    // after rendering children, if no mesh, do not render self
    if (!mesh)
        return;
    
    glPushMatrix();
    glLoadIdentity();
    
    glMultMatrixf(matrix);
    
    [mesh render];
    
    // restore the matrix
    glPopMatrix();
    
    // render children
    if (hasChildren && AX_ENABLE_RENDER_CHILDREN_ABOVE) {
        [children makeObjectsPerformSelector:@selector(render)];
    }
}

- (void)finalAwake {
    [_delegate submitForEvaluation:self];
}

- (void)dealloc {
    self.delegate = nil;
    
    [mesh release];
    [collider release];
    free(matrix);
    [super dealloc];
}

@end
