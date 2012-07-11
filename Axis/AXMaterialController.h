//
//  AXMaterialController.h
//  Axis
//
//  Created by Jethro Wilson on 30/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import "AXPoint.h"
#import "AXConfiguration.h"

@class AXTexturedQuad;
@class AXAnimatedQuad;

@interface AXMaterialController : NSObject {
    NSMutableDictionary *materialLibrary;
    NSMutableDictionary *quadLibrary;
}

+ (AXMaterialController*)sharedMaterialController;
- (AXAnimatedQuad*)animationFromAtlasKeys:(NSArray*)atlasKeys;
- (AXTexturedQuad*)quadFromAtlasKey:(NSString*)atlasKey;
- (AXTexturedQuad*)texturedQuadFromAtlasRecord:(NSDictionary *)record
                                     atlasSize:(CGSize)atlasSize
                                   materialKey:(NSString *)key;

- (CGSize)loadTextureImage:(NSString*)imageName materialKey:(NSString*)materialKey;
- (void)bindMaterial:(NSString *)materialKey;
- (void)loadAtlasData:(NSString *)atlasName;

- (id)init;
- (void)dealloc;

@end
