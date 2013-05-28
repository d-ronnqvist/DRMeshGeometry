//
//  DRSphereMeshGeometryBuilder.m
//  DRMeshGeometry
//
//  Created by David Rönnqvist on 5/28/13.
//  Copyright (c) 2013 David Rönnqvist. All rights reserved.
//

#import "DRSphereMeshGeometryBuilder.h"

@implementation DRSphereMeshGeometryBuilder

- (SCNGeometry *)geometryWithSphereFunction:(DRSphereMeshFunction)function
{
    self.xRange = self.thetaRange;
    self.zRange = self.psiRange;
    
    return [self geometryWithFunction:function];
}

- (SCNVector3)vectorForFunction:(DRMeshFunction)function X:(CGFloat)x Z:(CGFloat)z
{
    CGFloat psi = z;
    CGFloat theta = x;
    
    CGFloat r = function(x,z);
    
    return SCNVector3Make(r*sinf(theta)*cosf(psi),
                          r*sinf(theta)*sinf(psi),
                          r*cosf(theta));
}

@end
