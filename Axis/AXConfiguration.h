//
//  AXConfiguration.h
//  Axis
//
//  Created by Jethro Wilson on 21/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// Engine Setup
#define AX_ENABLE_DISPLAY_LINK 1
#define AX_ENABLE_POINT_PER_SECOND 0
#define AX_ENABLE_RETINA_DISPLAY 1
#define AX_ENABLE_MULTI_SCENE_MODE 0 // disable for performance
#define AX_USE_CONVERT_IMAGE_LOW_BITMAP 0

// Engine Debug
#define AX_DEBUG_DRAW_COLLIDERS 1

// Engine Console Debug
#define AX_CONSOLE_DISPLAY_ALL_FRAME_RATES 0
#define AX_CONSOLE_LOW_FRAME_RATE_WARNING 0
#define AX_CONSOLE_LOW_FRAME_RATE_WARNING_MARK 40.0

// Engine Calculus
#define RANDOM_SEED() srandom(time(NULL))
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__+1) - (__MIN__)))

// a handy constant to keep around
#define AX_CALC_RADIANS_TO_DEGREES 57.2958

// Particles
// ***** will be removed for custom number
#define AX_MAX_PARTICLES 100

// Game Constants

// the explosive force applied to the smaller rocks after a big rock has been smashed
#define SMASH_SPEED_FACTOR 0.75

#define TURN_SPEED_FACTOR 3.0
#define THRUST_SPEED_FACTOR 0.02