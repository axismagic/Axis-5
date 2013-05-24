//
//  AXSceneObject.m
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXSprite.h"
#import "AXDirector.h"
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

@synthesize mesh = _mesh, meshBounds = _meshBounds;
@synthesize colourVerts = _colourVerts;
@synthesize collider = _collider, collisionDetection = _collisionDetection;

#pragma mark - Init

- (id)init {
    self = [super init];
    if (self != nil) {
        _vectorFromParent = AXPointMake(0.0, 0.0, 0.0);
        
        _location = AXPointMake(0.0, 0.0, 0.0);
        _rotation = AXPointMake(0.0, 0.0, 0.0);
        _shear = CGPointMake(0, 0);
        _scale = AXPointMake(1.0, 1.0, 1.0);
        
        _colour = AXColourMake(1.0, 1.0, 1.0, 1.0);
        
        _colourVerts = (GLfloat*) malloc(4 * 4 * sizeof(GLfloat));
        
        _matrix = (CGFloat*) malloc(16 * sizeof(CGFloat));
        _collider = nil;
        
        _meshBounds = CGRectZero;
        
        _hasChildren = NO;
        _isChild = NO;
        
        _active = NO;
    }
    
    return self;
}

- (id)initWithSpriteImage:(NSString *)spriteName {
    self = [super init];
    if (self != nil) {
        // normal init
        [self init];
        // init mesh
        _mesh = [[AXMaterialController sharedMaterialController] quadFromAtlasKey:spriteName];
    }
    
    return self;
}

- (CGRect)meshBounds {
    if (CGRectEqualToRect(_meshBounds, CGRectZero)) {
        self.meshBounds = [AXMesh meshBounds:_mesh scale:_scale];
    }
    
    return _meshBounds;
}

#pragma mark - Activation

- (void)activate {
    [super activate];
    
    if (_collisionDetection) {
        self.collider = [AXCollider collider];
        // ***** needs set Yes or No?
        [self.collider setCheckForCollisions:YES];
        [_sceneDelegate addObjectCollider:self];
        [self.collider activate];
    }
}

- (void)deactivate {
    [super deactivate];
    
    if (_collisionDetection) {
        self.collisionDetection = NO;
        [_sceneDelegate removeObjectCollider:self];
    }
}

- (void)awake {
    // *R?*
    [super awake];
    // if delegate is set, invoke protocol for collision
    /*if (_spriteDelegate)
        [_spriteDelegate submitForEvaluation:self];*/
    
    
    // overridden
}

#pragma mark - Updates

/*- (void)update {
    if (!_updates)
        return;
    
    [super update];
    
    if (_collider != nil)
        [_collider updateCollider:self];
}*/

- (void)endUpdate {
    if (_collider != nil) {
        // **** optimise
        [_collider setScaleFromObject:self];
        [_collider updateWithMatrix:self.matrix];
        //[_collider updateCollider:self];
    }
}

#pragma mark Render

- (void)render {
    // if not active, do not render self or children
    if (!_active)
        return;
    
    // render children
    if (_hasChildren && !AX_ENABLE_RENDER_CHILDREN_ABOVE)
        [children makeObjectsPerformSelector:@selector(render)];
    
    // after rendering children, if no mesh, do not render self
    if (!_mesh) {
        // render children in case Renders children above and no mesh
        if (_hasChildren && AX_ENABLE_RENDER_CHILDREN_ABOVE)
            [children makeObjectsPerformSelector:@selector(render)];
        
        return;
    }
    
    // if renders, render self
    if (_renders) {
        glPushMatrix();
        //glLoadIdentity();
        
        //glMultMatrixf(self.matrix);
        
        glLoadMatrixf(self.matrix);
        
        [_mesh render];
        
        // restore matrix
        glPopMatrix();
    }
    
    // render children
    if (_hasChildren && AX_ENABLE_RENDER_CHILDREN_ABOVE)
        [children makeObjectsPerformSelector:@selector(render)];
}

#pragma mark Colours

- (void)setColour:(AXColour)colour {
    _colour = colour;
    [self setSpriteColour:_colour];
}

- (void)setSpriteColour:(AXColour)newColour {
    NSInteger vertexIndex = 0;
    for (vertexIndex = 0; vertexIndex < 16; vertexIndex += 4) {
        self.colourVerts[vertexIndex] = newColour.r;
        self.colourVerts[vertexIndex + 1] = newColour.g;
        self.colourVerts[vertexIndex + 2] = newColour.b;
        self.colourVerts[vertexIndex + 3] = newColour.a;
    }
    
    self.mesh.colors = self.colourVerts;
    self.mesh.colorStride = 4;
}

#pragma mark Collision Detection


- (void)didCollideWith:(AXSprite*)object {
    // do nothing, overridden.
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

/*- (void)addChild:(AXSprite *)child {
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
        if (!_hasChildren)
            self.hasChildren = YES;
    } else
        return;
}*/

// ***** method for removing children required

/*- (void)update {
    // update self, used in subclasses
    [self updateBeginningPhase];
    
    // work out relative position of children (offset)
    if (_hasChildren) {
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
}*/

@end
