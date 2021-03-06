//
//  AXCollider.m
//  Axis
//
//  Created by Jethro Wilson on 27/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXCollider.h"
#import "AXSprite.h"
#import "AXMesh.h"

#pragma mark circle mesh
static NSInteger BBCircleVertexStride = 2;
static NSInteger BBCircleColorStride = 4;

static NSInteger BBCircleOutlineVertexesCount = 20;
static CGFloat BBCircleOutlineVertexes[40] = {1.0000,0.0000,0.9511,0.3090,0.8090,0.5878,0.5878,0.8090,0.3090,0.9511,0.0000,1.0000,-0.3090,0.9511,-0.5878,0.8090,-0.8090,0.5878,-0.9511,0.3090,-1.0000,0.0000,-0.9511,-0.3090,-0.8090,-0.5878,-0.5878,-0.8090,-0.3090,-0.9511,-0.0000,-1.0000,0.3090,-0.9511,0.5878,-0.8090,0.8090,-0.5878,0.9511,-0.3090};

static CGFloat BBCircleColorValues[80] = 
{1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 
    1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0, 1.0,0.0,0.0,1.0} ;

@implementation AXCollider

@synthesize checkForCollisions, maxRadius;
@synthesize mesh = _mesh;

+ (AXCollider*)collider {
    AXCollider *collider = [[AXCollider alloc] init];
    if (AX_DEBUG_DRAW_COLLIDERS) {
        collider.active = YES;
        [collider awake];
    }
    collider.checkForCollisions = NO;
    return [collider autorelease];
}

- (void)updateCollider:(AXSprite*)sceneObject {
    // *R?*
    if (sceneObject == nil)
        return;
    
    // **** replace with custom matrix multiplication to ensure correct size, rotation and location set. This will also enable custom shapes - not just circles.
    transformedCentroid = AXPointMatrixMultiply([sceneObject mesh].centroid, [sceneObject matrix]);
    //transformedCentroid = AXPointMatrixMultiply(AXPointMake(1, 1, 0), [sceneObject matrix]);
    self.location = transformedCentroid;
    /*maxRadius = sceneObject.scale.x;
    if (maxRadius < sceneObject.scale.y)
        maxRadius = sceneObject.scale.y;
    if ((maxRadius < sceneObject.scale.z) && ([sceneObject mesh].vertexStride > 2))
        maxRadius = sceneObject.scale.z;*/
    // find largest scale
    maxRadius = sceneObject.scale.x;
    if (maxRadius <  sceneObject.scale.y)
        maxRadius = sceneObject.scale.y;
    if ((maxRadius < sceneObject.scale.z) && ([sceneObject mesh].vertexStride > 2))
        maxRadius = sceneObject.scale.z;
    
    // set radius
    maxRadius *= [sceneObject mesh].radius;
    
    // scene object iVars
    self.scale = AXPointMake(maxRadius, maxRadius, 1.0);
    
    glPushMatrix();
    glLoadIdentity();
    
    glTranslatef(self.location.x, self.location.y, self.location.z);
    glScalef(self.scale.x, self.scale.y, self.scale.z);
    
    // save matrix
    glGetFloatv(GL_MODELVIEW_MATRIX, self.matrix);
    // restore matrix
    glPopMatrix();
    
    //scale = AXPointMake([sceneObject mesh].radius * sceneObject.scale.x, [sceneObject mesh].radius * sceneObject.scale.y, 0.0);
}

- (void)setScaleFromObject:(AXSprite*)sceneObject {
    /*maxRadius = sceneObject.scale.x;
    if (maxRadius <  sceneObject.scale.y)
        maxRadius = sceneObject.scale.y;
    if ((maxRadius < sceneObject.scale.z) && ([sceneObject mesh].vertexStride > 2))
        maxRadius = sceneObject.scale.z;*/
    
    // set radius
    maxRadius = [sceneObject mesh].radius;
    
    // scene object iVars
    self.scale = AXPointMake(maxRadius, maxRadius, 1.0);
}

- (void)updateWithMatrix:(GLfloat *)parentMatrix {
    // if not active, do not update self or children
    if (!_active)
        return;
    
    [self beginUpdate];
    
    if (_updates) {
        
        self.scale = AXPointMake(maxRadius, maxRadius, 1.0);
        
        // update openGL on self
        glPushMatrix();
        
        glLoadMatrixf(parentMatrix);
        
        // **** needs to init with max radius so this doesn't need to be set in case of errors that pop up later with transformation order. Double check.
        glScalef(self.scale.x, self.scale.y, self.scale.z);
        
        // save matrix
        glGetFloatv(GL_MODELVIEW_MATRIX, self.matrix);
        // restore matrix
        glPopMatrix();
    }
    
    [self endUpdate];
}

- (BOOL)doesCollideWithCollider:(AXCollider*)aCollider {
    // *** Max radius not being calculated
    CGFloat collisionDistance = self.maxRadius + aCollider.maxRadius;
    CGFloat objectDistance = AXPointDistance(_location, aCollider.location);
    
    if (objectDistance < collisionDistance)
        return YES;
    return NO;
}

- (BOOL)doesCollideWithMesh:(AXSprite*)sceneObject {
    // *** Max radius not being calculated
    NSInteger index;
    for (index = 0; index < sceneObject.mesh.vertexCount; index++) {
        NSInteger position = index * sceneObject.mesh.vertexStride;
        AXPoint vert;
        if (sceneObject.mesh.vertexStride > 2) {
            vert = AXPointMake(sceneObject.mesh.vertexes[position], sceneObject.mesh.vertexes[position + 1], sceneObject.mesh.vertexes[position + 2]);
        } else {
            vert = AXPointMake(sceneObject.mesh.vertexes[position], sceneObject.mesh.vertexes[position + 1], 0.0);
        }
        
        vert = AXPointMatrixMultiply(vert, [sceneObject matrix]);
        CGFloat distance = AXPointDistance(_location, vert);
        if (distance < self.maxRadius)
            return YES;
    }
    return NO;
}

- (void)awake {
    self.mesh = [[AXMesh alloc] initWithVertexes:BBCircleOutlineVertexes
                                vertexCount:BBCircleOutlineVertexesCount
                               vertexStride:BBCircleVertexStride
                                renderStyle:GL_LINE_LOOP];
    _mesh.colors = BBCircleColorValues;
    _mesh.colorStride = BBCircleColorStride;
    
    self.active = YES;
}

- (void)render {
    if (!_mesh || !_active)
        return;
    glPushMatrix();
    //glLoadIdentity();
    glLoadMatrixf(self.matrix);
    //glTranslatef(self.location.x, self.location.y, self.location.z);
    //glScalef(self.scale.x, self.scale.y, self.scale.z);
    [self.mesh render];
    glPopMatrix();
}

- (void)dealloc {
    [super dealloc];
}

@end
