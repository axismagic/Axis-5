//
//  AXSpaceShip.m
//  Axis
//
//  Created by Jethro Wilson on 21/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXSpaceShip.h"

#import "AXMissile.h"
#import "AXCollider.h"
#import "AXRock.h"

#pragma mark Space Ship

/*
 static NSInteger BBSpaceShipVertexStride = 2;
 static NSInteger BBSpaceShipColorStride = 4;

 static NSInteger BBSpaceShipOutlineVertexesCount = 5;
 static CGFloat BBSpaceShipOutlineVertexes[10] = {0.0, 4.0,    3.0, -4.0,
    1.0, -2.0,   -1.0, -2.0,
    -3.0, -4.0};

 static CGFloat BBSpaceShipColorValues[20] = {1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0, 
    1.0,1.0,1.0,1.0, 1.0,1.0,1.0,1.0,
    1.0,1.0,1.0,1.0};
*/

@implementation AXSpaceShip

- (void)awake {
    /*
     mesh = [[AXMesh alloc] initWithVertexes:BBSpaceShipOutlineVertexes vertexCount:BBSpaceShipOutlineVertexesCount vertexStride:BBSpaceShipVertexStride renderStyle:GL_LINE_LOOP];
     mesh.colors = BBSpaceShipColorValues;
     mesh.colorStride = BBSpaceShipColorStride;
    */
    
    self.mesh = [[AXMaterialController sharedMaterialController] quadFromAtlasKey:@"ship"];
    self.scale = AXPointMake(40, 40, 1.0);
    
    self.collider = [AXCollider collider];
    [self.collider setCheckForCollisions:YES];
    
    [super awake];
}

- (void)update {
    [super update];
    
    CGFloat rightTurn = [[AXSceneController sharedSceneController].inputController rightMagnitude];
    CGFloat leftTurn = [[AXSceneController sharedSceneController].inputController leftMagnitude];
    
    _rotation.z += ((rightTurn * -1.0) + leftTurn) * TURN_SPEED_FACTOR;
    
    if ([[AXSceneController sharedSceneController].inputController fireMissile]) [self fireMissile];
    
    CGFloat forwardMag = [[AXSceneController sharedSceneController].inputController forwardMagnitude] * THRUST_SPEED_FACTOR;
    if (forwardMag <= 0.0001) return;
    
    CGFloat radians = _rotation.z/AX_CALC_RADIANS_TO_DEGREES;
    speed.x += sinf(radians) * -forwardMag;
    speed.y += cosf(radians) * forwardMag;
}

- (void)fireMissile {
    AXMissile *missile = [[AXMissile alloc] init];
    //missile.scale = AXPointMake(5.0, 5.0, 1.0);
    // position at tip of ship
    CGFloat radians = _rotation.z/AX_CALC_RADIANS_TO_DEGREES;
    CGFloat speedX = -sinf(radians) * 3.0;
    CGFloat speedY = cosf(radians) * 3.0;
    
    missile.speed = AXPointMake(speedX, speedY, 0.0);
    // missile.translation = AXPointMake(translation.x + missile.speed.x * 3.0, translation.y + missile.speed.y * 3.0, 0.0);
    missile.location = AXPointMatrixMultiply(AXPointMake(0.0, 0.5, 0.0), _matrix);
    missile.rotation = AXPointMake(0.0, 0.0, self.rotation.z);
    
    [[AXSceneController sharedSceneController] addObjectToScene:missile];
    [missile release];
    
    [[AXSceneController sharedSceneController].inputController setFireMissile:NO];
}

- (void)didCollideWith:(AXSprite*)sceneObject {
    if (![sceneObject isKindOfClass:[AXRock class]])
        return;
    if (![sceneObject.collider doesCollideWithMesh:self])
        return;
    
    // Collision successful
    [(AXRock*)sceneObject smash];
    // destroy ship
    [[AXSceneController sharedSceneController] removeObjectFromScene:self];
}

@end
