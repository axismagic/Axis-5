//
//  AXConfiguration.h
//  Axis
//
//  Created by Jethro Wilson on 21/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define RANDOM_SEED() srandom(time(NULL))
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__+1) - (__MIN__)))

// will draw the circles around the collision radius
// for debugging
#define DEBUG_DRAW_COLLIDERS 1

// the explosive force applied to the smaller rocks after a big rock has been smashed
#define SMASH_SPEED_FACTOR 0.75

#define TURN_SPEED_FACTOR 3.0
#define THRUST_SPEED_FACTOR 0.02

// a handy constant to keep around
#define BBRADIANS_TO_DEGREES 57.2958