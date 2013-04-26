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

#pragma mark - AXAC Action Enums

enum AXACActionTypes {
    AXACDelay = 0,
    AXACTransformationMovement = 1,
    AXACTransformationScale = 2,
    AXACTransformationRotation = 3,
    AXACAnimation = 4
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
