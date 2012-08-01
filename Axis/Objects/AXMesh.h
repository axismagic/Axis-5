//
//  AXMesh.h
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>

#import "AXPoint.h"

@interface AXMesh : NSObject {
    GLfloat *vertexes;
    GLfloat *colors;
    
    GLenum renderStyle;
    NSInteger vertexCount;
    NSInteger vertexStride;
    NSInteger colorStride;
    
    AXPoint centroid;
    CGFloat radius;
    
    CGSize _size;
}

@property (nonatomic, assign) NSInteger vertexCount;
@property (nonatomic, assign) NSInteger vertexStride;
@property (nonatomic, assign) NSInteger colorStride;
@property (nonatomic, assign) GLenum renderStyle;

@property (nonatomic, assign) GLfloat *vertexes;
@property (nonatomic, assign) GLfloat *colors;

@property (nonatomic, assign) AXPoint centroid;
@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) CGSize size;

- (id)initWithVertexes:(CGFloat*)verts
           vertexCount:(NSInteger)vertCount
          vertexStride:(NSInteger)vertStride
           renderStyle:(GLenum)style;
+ (CGRect)meshBounds:(AXMesh*)mesh scale:(AXPoint)scale;

- (AXPoint)calculateCentroid;
- (CGFloat)calculateRadius;

- (void)render;

@end
