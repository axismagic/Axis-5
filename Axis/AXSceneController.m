//
//  AXSceneController.m
//  Axis
//
//  Created by Jethro Wilson on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXSceneController.h"

#import "AXConfiguration.h"
#import "AXInputViewController.h"
#import "AXCollisionController.h"
#import "EAGLView.h"

#import "AXScene.h"

// *****
#import "AXSpaceShip.h"
#import "AXRock.h"
#import "AXParticleEmitter.h"

@implementation AXSceneController

@synthesize inputController = _inputController, openGLView = _openGLView;
@synthesize animationTimer, animationInterval;
@synthesize startDate = _startDate, deltaTime = _deltaTime;
@synthesize viewSize = _viewSize;

@synthesize activeSceneKey = _activeSceneKey;

+ (AXSceneController*)sharedSceneController {
    static AXSceneController *sharedSceneController;
    @synchronized(self) {
        if (!sharedSceneController)
            sharedSceneController = [[AXSceneController alloc] init];
    }
    
    return sharedSceneController;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        NSString *aSceneKey = [[NSString alloc] initWithString:@"NO_SCENE"];
        self.activeSceneKey = aSceneKey;
        [aSceneKey release];
        
        RANDOM_SEED();
    }
    
    return self;
}

#pragma  mark Scene Management

- (void)loadScene {
    // load the initial scene
    AXScene *scene = [[AXScene alloc] init];
    
    if (scenes == nil)
        scenes = [[NSMutableDictionary alloc] init];
    
    [scenes setObject:scene forKey:@"DEFAULT_SCENE_KEY"];
    [scene setUpdates:YES];
    
    [scene loadScene];
    
    // release scene
    [scene release];
}

- (void)loadScene:(AXScene*)scene forKey:(NSString*)sceneKey activate:(BOOL)activate {
    // ***** use keys to id scenes
    if (scenes == nil)
        scenes = [[NSMutableDictionary alloc] init];
    if (updatingSceneKeys == nil)
        updatingSceneKeys = [[NSMutableArray alloc] init];
    
    // add scene to dictionary with key
    [scenes setObject:scene forKey:sceneKey];
    // tell scene to load itself
    [scene loadScene];
    
    if (activate)
        [self activateScene:sceneKey];
    else
        [self deactivateScene:sceneKey];
}

- (void)removeSceneForKey:(NSString*)sceneKey {
    NSAssert(_activeSceneKey != sceneKey, @"Scene must not be active");
    
    [self deactivateScene:sceneKey];
    [scenes removeObjectForKey:sceneKey];
}

- (void)removeScene:(NSString*)sceneKey {
    // ***** remove specific scenes
}

- (void)activateScene:(NSString*)sceneKey {
    // get scene
    AXScene *scene = [scenes objectForKey:sceneKey];
    //activate scene
    [scene setUpdates:YES];
    // add scene key to updating keys array
    [updatingSceneKeys addObject:sceneKey];
    
    // set active scene key
    self.activeSceneKey = sceneKey;
    
    // deactivate current scene
    if (![_activeSceneKey isEqualToString:@"NO_SCENE"]) {
        NSLog(@"Did try to deactivate current scene");
        [self deactivateScene:_activeSceneKey];
    }
}

- (void)deactivateScene:(NSString*)sceneKey {
    AXScene *scene = [scenes objectForKey:sceneKey];
    // deactivate scene
    [scene setUpdates:NO];
    // remove scene from updating scene keys
    [updatingSceneKeys removeObject:sceneKey];
}

- (void)deactivateScenesExcept:(NSString*)sceneKey {
    for (NSString *key in scenes) {
        if (![key isEqualToString:sceneKey]) {
            /*AXScene *scene = [scenes objectForKey:sceneKey];
            [scene setUpdates:NO];*/
            [updatingSceneKeys removeObject:key];
        }
    }
}

- (void)updateSceneBehindTheScenes:(NSString*)sceneKey {
    for (NSString *key in scenes) {
        if ([key isEqualToString:sceneKey]) {
            AXScene *scene = [scenes objectForKey:sceneKey];
            [scene setUpdates:NO];
        }
    }
}

#pragma mark Loop Management

- (void)loop {
    // if mode != runnning, return; (enum: running, paused, etc)
    
    NSAutoreleasePool *aPool = [[NSAutoreleasePool alloc] init];
    
    // delta information
    thisFrameStartTime = [_startDate timeIntervalSinceNow];
    self.deltaTime = lastFrameStartTime - thisFrameStartTime;
    lastFrameStartTime = thisFrameStartTime;
    
    // current frame rate
    if (AX_CONSOLE_LOG_FRAME_RATE) {
        // display with warnings highlighted
        if (AX_CONSOLE_LOG_LOW_FRAME_RATE_WARNING) {
            // warning format or not for this frame
            if (1.0/_deltaTime < AX_CONSOLE_LOG_LOW_FRAME_RATE_WARNING_MARK)
                NSLog(@"Current Frame Rate LOW: %f", 1.0/_deltaTime);
            else
                NSLog(@"Current Frame Rate: %f", 1.0/_deltaTime);
        } else
            // display all in normal format, no warnings
            NSLog(@"Current Frame Rate: %f", 1.0/_deltaTime); 
    } else if (AX_CONSOLE_LOG_LOW_FRAME_RATE_WARNING) {
        // only warnings
        if (1.0/_deltaTime < AX_CONSOLE_LOG_LOW_FRAME_RATE_WARNING_MARK)
            NSLog(@"Current Frame Rate LOW: %f", 1.0/_deltaTime);
    }
    
    // add scenes to updating array
    
    // add scenes
    /*if ([scenesToAdd count] > 0) {
        [scenes addEntriesFromDictionary:scenesToAdd];
        //[scenes addObjectsFromArray:scenesToAdd];
        [scenesToAdd removeAllObjects];
    }*/
    
    [self updateScenes];
    [self renderScenes];
    
    [_inputController clearEvents];
    
    // remove scenes from updating array
    
    // remove scenes
    /*if ([scenesToRemove count] > 0) {
        [scenes removeObjectsForKeys:];
        //[scenes removeObjectsInArray:scenesToRemove];
        [scenesToRemove removeAllObjects];
    }*/
    
    [aPool release];
}

- (void)startLoop {
    self.animationInterval = 1.0/60.0;
    [self startAnimation];
    
    // reset clock
    self.startDate = [NSDate date];
    lastFrameStartTime = 0;
}

- (void)stopLoop {
    // ***** required?
}

#pragma mark Animation Management

- (void)startAnimation {
    if (AX_ENABLE_DISPLAY_LINK) {
        NSLog(@"Using Display Link");
        
        if (displayLink)
            return;
        
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(loop)];
        [displayLink retain];
        displayLink.frameInterval = 1;
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    } else {
        NSLog(@"Using Animation Timer");
        
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
    }
}

- (void)stopAnimation {
    if (AX_ENABLE_DISPLAY_LINK) {
        [displayLink invalidate];
        [displayLink release];
        displayLink = nil;
    } else {
        self.animationTimer = nil;
    }
}

- (void)setAnimationTimer:(NSTimer *)newTimer {
    [animationTimer invalidate];
    animationTimer = newTimer;
}

- (void)setAnimationInterval:(NSTimeInterval)interval {
    // ***** Fix?
    animationInterval = interval;
    if (animationTimer) {
        [self stopAnimation];
        [self startAnimation];
    }
}

#pragma mark -
#pragma mark Update Model

- (void)updateScenes {
    /* ***** updating behind the scenes
    for (NSString *searchKey in scenes) {
        AXScene *scene = [scenes objectForKey:searchKey];
        if (scene.updates)
            [scene updateModel];
    }*/
    
    if (AX_ENABLE_MULTI_SCENE_MODE) {
        // multi scene mode enabled
        // iterate over updating scenes
        for (NSString *searchKey in updatingSceneKeys) {
            AXScene *scene = [scenes objectForKey:searchKey];
            [scene updateScene];
        }
    } else {
        // single scene mode
        // only the scene that renders will update
        //AXScene *scene = [scenes objectForKey:_activeSceneKey];
        [[scenes objectForKey:_activeSceneKey] updateScene];
        //[scene updateScene];
    }
    /*AXScene *scene = [scenes objectForKey:activeSceneKey];
    [scene updateScene];
    */
    // loop through scenes, update them
    // ***** investigate performance
    /*for (AXScene *scene in scenes) {
        // update scenes
        if (scene.updates)
            [scene updateModel];
    }*/
}

#pragma mark Render Scene

- (void)renderScenes {
    // active OpenGL
    [_openGLView beginDraw]; // ***** rename renderFrameSetup
    
    // render active scene(s)?
    // ***** investigate performance
    AXScene *scene = [scenes objectForKey:_activeSceneKey];
    [scene renderScene];
    
    // finialse frame
    [_openGLView finishDraw]; // ***** rename renderFrame
}

#pragma mark Game Loop

/* - (void)gameLoop {
    // autorelease pool
    NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
    
    thisFrameStartTime = [levelStartDate timeIntervalSinceNow];
    deltaTime = lastFrameStartTime - thisFrameStartTime;
    lastFrameStartTime = thisFrameStartTime;
    
    // current frame rate
    if (AX_CONSOLE_DISPLAY_ALL_FRAME_RATES) {
        // display with warnings highlighted
        if (AX_CONSOLE_LOW_FRAME_RATE_WARNING) {
            // warning format or not for this frame
            if (1.0/deltaTime < AX_CONSOLE_LOW_FRAME_RATE_WARNING_MARK)                NSLog(@"Current Frame Rate LOW: %f", 1.0/deltaTime);
            else
                NSLog(@"Current Frame Rate: %f", 1.0/deltaTime);
        } else
            // display all in normal format, no warnings
            NSLog(@"Current Frame Rate: %f", 1.0/deltaTime); 
    } else if (AX_CONSOLE_LOW_FRAME_RATE_WARNING) {
        // only warnings
        if (1.0/deltaTime < AX_CONSOLE_LOW_FRAME_RATE_WARNING_MARK)
            NSLog(@"Current Frame Rate LOW: %f", 1.0/deltaTime);
    }
    
    // add queued scene objects
    if ([objectsToAdd count] > 0) {
        [sceneObjects addObjectsFromArray:objectsToAdd];
        [objectsToAdd removeAllObjects];
    }
    
    // apply inputs to objects in the scene
    [self updateModel];
    // deal with collisions
    [collisionController handleCollisions];
    // send objects to the renderer
    [self renderScene];
    
    // remove old objects
    if ([objectsToRemove count] > 0) {
        [sceneObjects removeObjectsInArray:objectsToRemove];
        [objectsToRemove removeAllObjects];
    }
    
    [apool release];
}*/

/*- (void)updateModel {
    // call update on all interface objects
    [inputController updateInterface];
    // call update on all objects
    [sceneObjects makeObjectsPerformSelector:@selector(update)];*/
    /*for (AXSceneObject *object in sceneObjects) {
        if (!object.isChild)
            [object update];
    }*/
    // clear events
    /*[inputController clearEvents];
}*/

/*- (void)renderScene {
    // turn openGL 'on'
    [openGLView beginDraw];
    // call render on all objects in the scene
    [sceneObjects makeObjectsPerformSelector:@selector(render)];
    // draw interface on top of everything
    [inputController renderInterface];
    // finilise frame
    [openGLView finishDraw];
}

- (void)addObjectToScene:(AXSceneObject *)sceneObject {
    if (objectsToAdd == nil)
        objectsToAdd = [[NSMutableArray alloc] init];
    // activate and wake object
    sceneObject.active = YES;
    [sceneObject awake];
    [objectsToAdd addObject:sceneObject];
}

- (void)removeObjectFromScene:(AXSceneObject *)sceneObject {
    if (objectsToRemove == nil)
        objectsToRemove = [[NSMutableArray alloc] init];
    [objectsToRemove addObject:sceneObject];
}*/

#pragma mark Dealloc

- (void)dealloc {
    [self stopAnimation];
    
    // *****
    self.inputController = nil;
    self.openGLView = nil;
    [collisionController release];
    [super dealloc];
}

@end
