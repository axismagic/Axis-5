//
//  AXMaterialController.m
//  Axis
//
//  Created by Jethro Wilson on 30/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXMaterialController.h"

#import "AXTexturedQuad.h"
#import "AXAnimatedQuad.h"

@implementation AXMaterialController

+ (AXMaterialController*)sharedMaterialController {
    static AXMaterialController *sharedMaterialController;
    @synchronized(self) {
        if (!sharedMaterialController)
            sharedMaterialController = [[AXMaterialController alloc] init];
        
        // return sharedMaterialController;
    }
    
    return sharedMaterialController;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        [self loadAtlasData:@"SpaceRocksAtlas"];
    }
    
    return self;
}

#pragma mark Atlas Sheet

- (void)loadAtlasData:(NSString *)atlasName {
    NSAutoreleasePool *aPool = [[NSAutoreleasePool alloc] init];
    
    if (quadLibrary == nil)
        quadLibrary = [[NSMutableDictionary alloc] init];
    
    CGSize atlasSize = [self loadTextureImage:[atlasName stringByAppendingPathExtension:@"png"] materialKey:atlasName];
    
    NSArray *itemData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:atlasName ofType:@"plist"]];
    
    for (NSDictionary *record in itemData) {
        AXTexturedQuad *quad = [self texturedQuadFromAtlasRecord:record atlasSize:atlasSize materialKey:atlasName];
        [quadLibrary setObject:quad forKey:[record objectForKey:@"name"]];
    }
    
    [self bindMaterial:atlasName];
    
    [aPool release];
}

- (AXTexturedQuad*)texturedQuadFromAtlasRecord:(NSDictionary *)record atlasSize:(CGSize)atlasSize materialKey:(NSString *)key {
    AXTexturedQuad *quad = [[AXTexturedQuad alloc] init];
    
    GLfloat xLocation = [[record objectForKey:@"xLocation"] floatValue];
    GLfloat yLocation = [[record objectForKey:@"yLocation"] floatValue];
    GLfloat width = [[record objectForKey:@"width"] floatValue];
    GLfloat height = [[record objectForKey:@"height"] floatValue];
    
    // find normalized texture coordinates
    GLfloat uMin = xLocation/atlasSize.width;
    GLfloat vMin = yLocation/atlasSize.height;
    GLfloat uMax = (xLocation + width)/atlasSize.width;
    GLfloat vMax = (yLocation + height)/atlasSize.height;
    
    quad.uvCoordinates[0] = uMin;
    quad.uvCoordinates[1] = vMax;
    
    quad.uvCoordinates[2] = uMax;
    quad.uvCoordinates[3] = vMax;
    
    quad.uvCoordinates[4] = uMin;
    quad.uvCoordinates[5] = vMin;
    
    quad.uvCoordinates[6] = uMax;
    quad.uvCoordinates[7] = vMin;
    
    quad.materialKey = key;
    
    return  [quad autorelease];
}

- (AXTexturedQuad*)quadFromAtlasKey:(NSString *)atlasKey {
    return [quadLibrary objectForKey:atlasKey];
}

- (AXAnimatedQuad*)animationFromAtlasKeys:(NSArray *)atlasKeys {
    AXAnimatedQuad *animation = [[AXAnimatedQuad alloc] init];
    for (NSString *key in atlasKeys)
        [animation addFrame:[self quadFromAtlasKey:key]];
    
    return [animation autorelease];
}

#pragma mark Material Functions

- (void)bindMaterial:(NSString*)materialKey {
    /*
     grab stored ID and tell OpenGL to bind this texture.
     whenever a triangle is drawn, it is rendered with this texture.
     Binding textures can be expensive, so best to render groupd with the same texture at the same time to avoid binding.
    */
    
    NSNumber *numberObj = [materialLibrary objectForKey:materialKey];
    if (numberObj == nil)
        return;
    
    GLuint textureID = [numberObj unsignedIntValue];
    
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, textureID);
}

- (CGSize)loadTextureImage:(NSString*)imageName materialKey:(NSString*)materialKey {
    CGContextRef spriteContext;
    GLubyte *spriteData;
    size_t width, height;
    GLuint textureID;
    
    // grab the image from the file system
    UIImage *uiImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:nil]];
    CGImageRef spriteImage = [uiImage CGImage];
    
    // power of 2, from 2 - 1024. Do not need to be square
    width = CGImageGetWidth(spriteImage);
    height = CGImageGetHeight(spriteImage);
    
    CGSize imageSize = CGSizeMake(width, height);
    
    if (spriteImage) {
        // allocated memory needed for bitmap context
        spriteData = (GLubyte*)malloc(width * height * 4);
        memset(spriteData, 0, (width * height * 4)); 
        // create context with right size and format
        spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width * 4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
        // draw image into the context
        CGContextDrawImage(spriteContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), spriteImage);
        // get rid of context, end of life to avoid memory leaks
        CGContextRelease(spriteContext);
        
        // use OpenGL ES to generate a new name for the texture
        glGenTextures(1, &textureID);
        // beind texture name
        glBindTexture(GL_TEXTURE_2D, textureID);
        
        // Convert RRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA to RRRRGGGGBBBBAAAA
        // makes images take up half as much space in memory
        // but will lose half of color depth
        
        if (AX_USE_CONVERT_IMAGE_LOW_BITMAP) {
            void *tempData;
            unsigned int *inPixel32;
            unsigned short *outPixel16;
            
            tempData = malloc(height * width * 2);
            
            inPixel32 = (unsigned int*)spriteData;
            outPixel16 = (unsigned short*)tempData;
            
            NSUInteger i;
            for(i = 0; i < width * height; ++i, ++inPixel32)
                *outPixel16++ = ((((*inPixel32 >> 0) & 0xFF) >> 4) << 12) | ((((*inPixel32 >> 8) & 0xFF) >> 4) << 8) | ((((*inPixel32 >> 16) & 0xFF) >> 4) << 4) | ((((*inPixel32 >> 24) & 0xFF) >> 4) << 0);
            
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_SHORT_4_4_4_4, tempData);
            free(tempData);
        } else {
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
        }
        
        free(spriteData);
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        
        // enable use of the texture
        glEnable(GL_TEXTURE_2D);
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        // enable blending
        glEnable(GL_BLEND);
    } else {
        NSLog(@"No Texture");
        return CGSizeZero;
    }
    
    [uiImage release];
    
    if (materialLibrary == nil)
        materialLibrary = [[NSMutableDictionary alloc] init];
    
    // put texture ID into the library
    [materialLibrary setObject:[NSNumber numberWithUnsignedInt:textureID] forKey:materialKey];
    
    return imageSize;
}

- (void)dealloc {
    [materialLibrary release];
    [super dealloc];
}

@end
