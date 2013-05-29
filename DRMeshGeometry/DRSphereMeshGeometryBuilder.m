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
    self.rangeOne = self.thetaRange;
    self.rangeTwo = self.psiRange;
    
    return [self geometryWithFunction:function];
}

- (SCNVector3)vectorForFunction:(DRMeshFunction)function one:(CGFloat)x two:(CGFloat)z
{
    CGFloat psi = z;
    CGFloat theta = x;
    
    CGFloat r = function(x,z);
    
    return SCNVector3Make(r*sinf(theta)*cosf(psi),
                          r*sinf(theta)*sinf(psi),
                          r*cosf(theta));
}

@end
