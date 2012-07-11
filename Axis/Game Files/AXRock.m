//
//  AXRock.m
//  Axis
//
//  Created by Jethro Wilson on 21/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXRock.h"
#import "AXCollider.h"

#pragma mark Rocks Mesh

static NSInteger BBRockVertexStride = 2;
static NSInteger BBRockColorStride = 4;
static NSInteger BBRockOutlineVertexesCount = 16;

@implementation AXRock

@synthesize smashCount;

- (id)init {
    self = [super init];
    if (self != nil) {
        smashCount = 0;
    }
    
    return self;
}

+ (AXRock*)randomRock {
    return [AXRock randomRockWithScale:NSMakeRange(15, 20)];
}

+ (AXRock*)randomRockWithScale:(NSRange)scaleRange {
    AXRock *rock = [[AXRock alloc] init];
    CGFloat scale = RANDOM_INT(scaleRange.location, NSMaxRange(scaleRange));
    rock.scale = AXPointMake(scale, scale, 1.0);
    CGFloat x = RANDOM_INT(100, 230);
    NSInteger flipX = RANDOM_INT(1, 10);
    if (flipX <= 5)
        x *= -1.0;
    CGFloat y = RANDOM_INT(0, 320) - 160;
    rock.translation = AXPointMake(x, y, 0.0);
    
    // moving up or down the y axis
    CGFloat speed = RANDOM_INT(1, 100)/100.0;
    NSInteger flipY = RANDOM_INT(1, 10);
    if (flipY <= 5)
        speed *= -1.0;
    rock.speed = AXPointMake(0.0, speed, 0.0);
    
    CGFloat rotSpeed = RANDOM_INT(1, 100)/200.0;
    NSInteger flipRot = RANDOM_INT(1, 10);
    if (flipRot <= 5)
        rotSpeed *= -1.0;
    rock.rotationalSpeed = AXPointMake(0.0, 0.0, rotSpeed);
    
    return [rock autorelease];
}

- (void)awake {
    NSInteger myVertexCount = RANDOM_INT(8, BBRockOutlineVertexesCount);
    
    // malloc memory for vertexes and colors
    verts = (CGFloat *) malloc(myVertexCount * BBRockVertexStride * sizeof(CGFloat));
    colors = (CGFloat *) malloc(myVertexCount * BBRockColorStride * sizeof(CGFloat));
    
    CGFloat radians =  0.0;
    CGFloat radianIncrement = (2.0 * 3.14159) / (CGFloat)myVertexCount;
    
    // generate vertexes
    NSInteger vertexIndex = 0;
    for (vertexIndex = 0; vertexIndex < myVertexCount; vertexIndex++) {
        NSInteger position = vertexIndex * BBRockVertexStride;
        CGFloat radiusAdjust = 0.25 - (RANDOM_INT(1,100)/100.0 * 0.5);
        verts[position] = cosf(radians) * (1.0 + radiusAdjust);
        verts[position + 1] = sinf(radians) * (1.0 + radiusAdjust);
        
        radians += radianIncrement;
    }
    
    for (vertexIndex = 0; vertexIndex < myVertexCount * BBRockColorStride; vertexIndex++) {
        colors[vertexIndex] = 1.0;
    }
    
    mesh = [[AXMesh alloc] initWithVertexes:verts vertexCount:myVertexCount vertexStride:BBRockVertexStride renderStyle:GL_LINE_LOOP];
    mesh.colors = colors;
    mesh.colorStride = BBRockColorStride;
    
    self.collider = [AXCollider collider];
}

- (void)smash {
    smashCount++;
    // queue for removal
    [[AXSceneController sharedSceneController] removeObjectFromScene:self];
    
    if (smashCount >= 2)
        return;
    
    NSInteger smallRockScale = scale.x / 3.0;
    
    AXRock *newRock = [[AXRock alloc] init];
    newRock.scale = AXPointMake(smallRockScale, smallRockScale, 1.0);
    AXPoint position = AXPointMake(0.0, 5.0, 0.0);
    newRock.translation = AXPointMatrixMultiply(position, matrix);
    newRock.speed = AXPointMake(speed.x + (position.x * SMASH_SPEED_FACTOR), speed.y + (position.y * SMASH_SPEED_FACTOR), 0.0);
    newRock.rotationalSpeed = rotationalSpeed;
    newRock.smashCount = smashCount;
    [[AXSceneController sharedSceneController] addObjectToScene:newRock];
    [newRock release];
    
    newRock = [[AXRock alloc] init];
    newRock.scale = AXPointMake(smallRockScale, smallRockScale, 1.0);
    position = AXPointMake(0.35, -0.35, 0.0);
    newRock.translation = AXPointMatrixMultiply(position, matrix);
    newRock.speed = AXPointMake(speed.x + (position.x * SMASH_SPEED_FACTOR), speed.y + (position.y * SMASH_SPEED_FACTOR), 0.0);
    newRock.rotationalSpeed = rotationalSpeed;
    newRock.smashCount = smashCount;
    [[AXSceneController sharedSceneController] addObjectToScene:newRock];
    [newRock release];
    
    newRock = [[AXRock alloc] init];
    newRock.scale = AXPointMake(smallRockScale, smallRockScale, 1.0);
    position = AXPointMake(-0.35, -0.35, 0.0);
    newRock.translation = AXPointMatrixMultiply(position, matrix);
    newRock.speed = AXPointMake(speed.x + (position.x * SMASH_SPEED_FACTOR), speed.y + (position.y * SMASH_SPEED_FACTOR), 0.0);
    newRock.rotationalSpeed = rotationalSpeed;
    newRock.smashCount = smashCount;
    [[AXSceneController sharedSceneController] addObjectToScene:newRock];
    [newRock release];
}

@end