//
//  AXHeroOne.m
//  Axis
//
//  Created by Jethro Wilson on 18/05/2013.
//
//

#import "AXHeroOne.h"

#import "AXInputProtocol.h"

#import "AXEnemy.h"

@implementation AXHeroOne

- (void)activate {
    [super activate];
    //[[[AXDirector sharedDirector] inputController] registerObjectForTouches:self swallowsTouchesType:AXInputObjectSwallows];
}

- (void)update {
    // if not active, do not update self or children
    if (!_active)
        return;
    
    // preUpdate
    [self preUpdate];
    
    // add new objects
    if ([childrenToAdd count] > 0) {
        if (children == nil)
            children = [[NSMutableArray alloc] init];
        
        [children addObjectsFromArray:childrenToAdd];
        [childrenToAdd removeAllObjects];
    }
    
    // work out relative positions of children (their offset from self)
    /*if (_hasChildren) {
     // loop through children and work out relative position
     for (AXObject *child in children) {
     // work out relative position
     AXPoint childRelativePosition = AXPointMake(child.location.x - _location.x,
     child.location.y - _location.y,
     child.location.z - _location.z);
     
     // give child new relative position
     child.vectorFromParent = childRelativePosition;
     }
     }*/
    
    if (_updates) {
        
        // update actions
        [self updateActions];
        
        // midPhase Updates - used in mobile object
        [self midPhaseUpdate];
        
        // update openGL on self
        glPushMatrix();
        glLoadIdentity();
        
        // move to my position
        glTranslatef(self.location.x, self.location.y, self.location.z);
        
        // rotate
        glRotatef(self.rotation.x, 1.0f, 0.0f, 0.0f);
        glRotatef(self.rotation.y, 0.0f, 1.0f, 0.0f);
        glRotatef(self.rotation.z, 0.0f, 0.0f, 1.0f);
        
        // width and height set in render
        //[self secondMidPhaseUpdate];
        
        // scale
        glScalef(self.scale.x, self.scale.y, self.scale.z);
        
        // save matrix
        glGetFloatv(GL_MODELVIEW_MATRIX, self.matrix);
        // restore matrix
        glPopMatrix();
    }
    
    // ***** update collider? - perhaps in sprite, moved to postUpdate
    
    // update children with new positions from thier saved relative ones
    if (_hasChildren) {
        for (AXEnemy *child in children) {
            
            child.pMat = self.matrix;
            //AXPoint newLoc = AXPointMatrixMultiply(AXPointMake(1, 1, 0), self.matrix);
            //child.location = newLoc;
        }
        /*for (AXObject *child in children) {
         AXPoint childNewPosition = AXPointMake(_location.x + child.vectorFromParent.x,
         _location.y + child.vectorFromParent.y,
         _location.z + child.location.z);
         
         child.location = childNewPosition;
         }*/
        
        // update all children
        [children makeObjectsPerformSelector:@selector(update)];
    }
    
    // remove old child objects
    if ([childrenToRemove count] > 0) {
        [children removeObjectsInArray:childrenToRemove];
        [childrenToRemove removeAllObjects];
        
        if ([children count] == 0)
            self.hasChildren = NO;
    }
    
    // postUpdate
    [self postUpdate];
}

- (void)render {
    // if not active, do not render self or children
    if (!_active)
        return;
    
    // render children
    if (_hasChildren && !AX_ENABLE_RENDER_CHILDREN_ABOVE)
        [children makeObjectsPerformSelector:@selector(render)];
    
    // after rendering children, if no mesh, do not render self
    if (!_mesh) {
        // render children in case Renders children above and no mesh
        if (_hasChildren && AX_ENABLE_RENDER_CHILDREN_ABOVE)
            [children makeObjectsPerformSelector:@selector(render)];
        
        return;
    }
    
    // if renders, render self
    if (_renders) {
        glPushMatrix();
        //glLoadIdentity();
        
        //glMultMatrixf(self.matrix);
        glLoadMatrixf(self.matrix);
        //[self secondMidPhaseUpdate];
        
        [_mesh render];
        
        // restore matrix
        glPopMatrix();
    }
    
    // render children
    if (_hasChildren && AX_ENABLE_RENDER_CHILDREN_ABOVE)
        [children makeObjectsPerformSelector:@selector(render)];
}

#pragma mark - Touches

- (BOOL)axTouchIsMine:(UITouch *)touch {
    // get touch location
    CGPoint touchPoint = [touch locationInView:[touch view]];
    CGSize correctSize = [[AXDirector sharedDirector] viewSize];
    AXPoint correctPoint = AXPointMake(touchPoint.x, correctSize.height - touchPoint.y, 0);
    
    CGFloat distance = AXPointDistance(self.location, correctPoint);
    if (distance < self.meshBounds.size.height/2) {
        NSLog(@"Touch Claimed");
        return YES;
    } else {
        return NO;
    }
}

- (void)axTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Hero1 Touch Began");
}

@end
