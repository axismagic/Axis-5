//
//  AXTexturedQuad.h
//  Axis
//
//  Created by Jethro Wilson on 01/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXMesh.h"
#import "AXMaterialController.h"

@interface AXTexturedQuad : AXMesh {
    GLfloat *uvCoordinates;
    NSString *materialKey;
}

@property (assign) GLfloat *uvCoordinates;
@property (retain) NSString *materialKey;

@end
