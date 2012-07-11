//
//  AXCollider.m
//  Axis
//
//  Created by Jethro Wilson on 27/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXCollider.h"
#import "AXSceneObject.h"
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

+ (AXCollider*)collider {
    AXCollider *collider = [[AXCollider alloc] init];
    if (AX_DEBUG_DRAW_COLLIDERS) {
        collider.active = YES;
        [collider awake];
    }
    collider.checkForCollisions = NO;
    return [collider autorelease];
}

- (void)updateCollider:(AXSceneObject*)sceneObject {
    if (sceneObject == nil)
        return;
    
    transformedCentroid = AXPointMatrixMultiply([sceneObject mesh].centroid, [sceneObject matrix]);
    translation = transformedCentroid;
    maxRadius = sceneObject.scale.x;
    if (maxRadius < sceneObject.scale.y)
        maxRadius = sceneObject.scale.y;
    if ((maxRadius < sceneObject.scale.z) && ([sceneObject mesh].vertexStride > 2))
        maxRadius = sceneObject.scale.z;
    
    maxRadius *= [sceneObject mesh].radius;
    
    // scene object iVars
    scale = AXPointMake(maxRadius, maxRadius, 1.0);
    //scale = AXPointMake([sceneObject mesh].radius * sceneObject.scale.x, [sceneObject mesh].radius * sceneObject.scale.y, 0.0);
}

- (BOOL)doesCollideWithCollider:(AXCollider*)aCollider {
    CGFloat collisionDistance = self.maxRadius + aCollider.maxRadius;
    CGFloat objectDistance = AXPointDistance(self.translation, aCollider.translation);
    
    if (objectDistance < collisionDistance)
        return YES;
    return NO;
}

- (BOOL)doesCollideWithMesh:(AXSceneObject*)sceneObject {
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
        CGFloat distance = AXPointDistance(self.translation, vert);
        if (distance < self.maxRadius)
            return YES;
    }
    return NO;
}

- (void)awake {
    mesh = [[AXMesh alloc] initWithVertexes:BBCircleOutlineVertexes
                                vertexCount:BBCircleOutlineVertexesCount
                               vertexStride:BBCircleVertexStride
                                renderStyle:GL_LINE_LOOP];
    mesh.colors = BBCircleColorValues;
    mesh.colorStride = BBCircleColorStride;
}

- (void)render {
    if (!mesh || !active)
        return;
    glPushMatrix();
    glLoadIdentity();
    glTranslatef(translation.x, translation.y, translation.z);
    glScalef(scale.x, scale.y, scale.z);
    [mesh render];
    glPopMatrix();
}

- (void)dealloc {
    [super dealloc];
}

@end
