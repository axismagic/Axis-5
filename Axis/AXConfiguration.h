//
//  AXConfiguration.h
//  Axis
//
//  Created by Jethro Wilson on 21/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// Engine Setup
#define AX_ENABLE_DISPLAY_LINK 1 // better frame rate performance - available iOS 3.0+
#define AX_ENABLE_POINT_PER_SECOND 0 // **** not available engine wide
#define AX_ENABLE_RETINA_DISPLAY 1 // if on, engine will use retina display when available
#define AX_ENABLE_MULTI_SCENE_MODE 0 // disable for performance
#define AX_ENABLE_RENDER_CHILDREN_ABOVE 1
#define AX_USE_CONVERT_IMAGE_LOW_BITMAP 0

// Engine Debug
#define AX_DEBUG_DRAW_COLLIDERS 1

// Engine Console Debug
#define AX_CONSOLE_LOG_FRAME_RATE 0 // Show Main Frame Rate
#define AX_CONSOLE_LOG_LOW_FRAME_RATE_WARNING 1 // Highlight Low Frame
#define AX_CONSOLE_LOG_LOW_FRAME_RATE_WARNING_MARK 50.0 // Low Frame Mark

// Silence Touch Warnings
#define AX_CONSOLE_SILIENCE_TOUCH_WARNINGS 0 // will not log console wanings when object does not respond to selector

// Engine Calculus
#define RANDOM_SEED() srandom(time(NULL))
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__+1) - (__MIN__)))

// a handy constant to keep around
#define AX_CALC_RADIANS_TO_DEGREES 57.2958

// Particles
// ***** will be removed for custom number
#define AX_MAX_PARTICLES 100

// Game Constants
// ***** will be removed

// the explosive force applied to the smaller rocks after a big rock has been smashed
#define SMASH_SPEED_FACTOR 0.75