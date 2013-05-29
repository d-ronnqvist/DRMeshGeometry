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

- (SCNVector3)vectorForFunction:(DRMeshFunction)function
                            one:(CGFloat)one
                            two:(CGFloat)two
{
    CGFloat theta = one;
    CGFloat fi = two;
    
    CGFloat r = function(theta,fi);
    
    return SCNVector3Make(r*sinf(theta)*cosf(fi),
                          r*sinf(theta)*sinf(fi),
                          r*cosf(theta));
}

@end
