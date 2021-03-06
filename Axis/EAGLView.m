//
//  EAGLView.m
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "EAGLView.h"
#import "AXConfiguration.h"
#import "AXDataConstructs.h"

#import "AXDirector.h"

#define USE_DEPTH_BUFFER 0

@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;

- (BOOL)createFrameBuffer;
- (void)destroyFrameBuffer;

@end

@implementation EAGLView

@synthesize context;

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)rect {
    if ((self = [super initWithFrame:rect])) {
        // get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], 
                                        kEAGLDrawablePropertyRetainedBacking, 
                                        kEAGLColorFormatRGBA8, 
                                        kEAGLDrawablePropertyColorFormat, nil];
        
        // ES1
        // ***** Potential allow for ES2 when init in Third Axis allowed
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;
        }
        
        // ***** control mutliple touches?
        self.multipleTouchEnabled = YES;
        
        if (AX_ENABLE_RETINA_DISPLAY) {
            self.contentScaleFactor = [[UIScreen mainScreen] scale];
            
            if (self.contentScaleFactor == 2.0)
                NSLog(@"Retina Display Active");
            else
                NSLog(@"Retina Display Not Available");
        }
        
    }
    
    return self;
}


// *R?*
/*- (void)setupViewPortrait {
    glViewport(0, 0, backingWidth, backingHeight);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(-1.0f, 1.0f, -1.5f, 1.5f, -1.0f, 1.0f);
    
    glMatrixMode(GL_MODELVIEW);
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
}

- (void)setupViewLandscape {
    glViewport(0, 0, backingWidth, backingHeight);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glRotatef(-90.0f, 0.0f, 0.0f, 1.0f);
    if (self.contentScaleFactor == 2.0)
        glOrthof(-backingHeight/4.0, backingHeight/4.0, -backingWidth/4.0, backingWidth/4.0, -1.0f, 1.0f);
    else
        glOrthof(-backingHeight/2.0, backingHeight/2.0, -backingWidth/2.0, backingWidth/2.0, -1.0f, 1.0f);
    
    glMatrixMode(GL_MODELVIEW);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
}*/

- (void)setupViewType:(NSInteger)viewType {
    glViewport(0, 0, backingWidth, backingHeight);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    
    // opengl origin, bottom left
    // ***** add choice of origin locations
    // view type portrait
    if (self.contentScaleFactor == 2.0)
        glOrthof(0, backingWidth/2.0, 0, backingHeight/2.0, -1.0f, 1.0f);
    else
        glOrthof(0, backingWidth, 0, backingHeight, -1.0f, 1.0f);
    
    [[AXDirector sharedDirector] setViewSize:self.bounds.size];
    
    NSLog(@"Screen Size: %f x %f", self.bounds.size.width, self.bounds.size.height);
    
    glMatrixMode(GL_MODELVIEW);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
}

- (void)beginDraw {
    [EAGLContext setCurrentContext:context];
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    
    glMatrixMode(GL_MODELVIEW);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glLoadIdentity();
}

- (void)finishDraw {
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void)layoutSubviews {
    [EAGLContext setCurrentContext:context];
    [self destroyFrameBuffer];
    [self createFrameBuffer];
    //[self setupViewLandscape];
    [self setupViewType:AXVTPortrait];
}

- (BOOL)createFrameBuffer {
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"Failed to make complete FrameBuffer Object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}

- (void)destroyFrameBuffer {
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if (depthRenderbuffer) {
        glDeleteRenderbuffers(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}

-(void)perspectiveFovY:(GLfloat)fovY 
                aspect:(GLfloat)aspect 
                 zNear:(GLfloat)zNear
                  zFar:(GLfloat)zFar {
	const GLfloat pi = 3.1415926;
	//	Half of the size of the x and y clipping planes.
	// - halfWidth = left, halfWidth = right
	// - halfHeight = bottom, halfHeight = top
	GLfloat halfWidth, halfHeight;
	//	Calculate the distance from 0 of the y clipping plane. Basically trig to calculate
	//	position of clip plane at zNear.
	halfHeight = tan( (fovY / 2) / 180 * pi ) * zNear;	
	//	Calculate the distance from 0 of the x clipping plane based on the aspect ratio.
	halfWidth = halfHeight * aspect;
	//	Finally call glFrustum with our calculated values.
	glFrustumf( -halfWidth, halfWidth, -halfHeight, halfHeight, zNear, zFar );
}

- (void)dealloc {
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [context release];
    [super dealloc];
}

@end
