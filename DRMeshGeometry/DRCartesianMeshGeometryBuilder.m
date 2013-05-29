//
//  DRCartesianMeshGeometryBuilder.m
//  DRMeshGeometry
//
//  Created by David Rönnqvist on 5/29/13.
//  Copyright (c) 2013 David Rönnqvist. All rights reserved.
//

#import "DRCartesianMeshGeometryBuilder.h"

@implementation DRCartesianMeshGeometryBuilder


- (SCNGeometry *)geometryWithCartesianFunction:(DRCartesianMeshFunction)function
{
    self.rangeOne = self.xRange;
    self.rangeTwo = self.zRange;
    
    return [self geometryWithFunction:function];
}

- (SCNVector3)vectorForFunction:(DRMeshFunction)function
                            one:(CGFloat)one
                            two:(CGFloat)two
{
    CGFloat x = one;
    CGFloat z = two;
    
    return SCNVector3Make(x,
                          function(x, z),
                          z);
}


@end
