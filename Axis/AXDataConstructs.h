//
//  AXDataConstructs.h
//  Axis
//
//  Created by Jethro Wilson on 25/04/2013.
//
//

#pragma mark - View Types

enum AXViewTypes {
    AXVTPortrait = 0,
    AXVTlandscape = 1
};

#pragma mark - Touches

typedef enum {
    AXTouchPhaseBegan = 0,
    AXTouchPhaseMoved = 1,
    AXTouchPhaseStationary = 2,
    AXTouchPhaseEnded = 3,
    AXTouchPhaseCancelled = 4,
} AXTouchPhase;

#pragma mark - AXAC Action Enums

enum AXACActionTypes {
    AXACDelay = 0,
    AXACTypeSet = 1,
    AXACTransformationMovement = 2,
    AXACTransformationScale = 3,
    AXACTransformationRotation = 4,
    AXACAnimation = 5,
};

enum AXACActionModes {
    AXACTransformTo = 0,
    AXACTransformBy = 1
};

enum AXACActionQueueModes {
    AXACQueueSetQueue = 0,
    AXACQueueSetNoQueue_InterruptCurrent = 1,
    AXACQueueSetNoQueue_IgnoreNew = 2,
    AXACQueueSetNoQueue_RunAllSimultaneous = 3
};

enum AXACActionSetModes {
    AXACActionSetRunModeQueue = 0,
    AXACActionSetRunModeSimultaneous = 1
};
