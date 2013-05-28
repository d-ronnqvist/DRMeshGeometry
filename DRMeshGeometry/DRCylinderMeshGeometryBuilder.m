//
//  DRCylinderMeshGeometryBuilder.m
//  DRMeshGeometry
//
//  Created by David Rönnqvist on 5/28/13.
//  Copyright (c) 2013 David Rönnqvist. All rights reserved.
//

#import "DRCylinderMeshGeometryBuilder.h"

@implementation DRCylinderMeshGeometryBuilder

- (SCNGeometry *)geometryWithCylinderFunction:(DRCylinderMeshFunction)function
{
    self.xRange = self.thetaRange;
    self.zRange = self.yRange;
    
    return [self geometryWithFunction:function];
}

- (SCNVector3)vectorForFunction:(DRMeshFunction)function X:(CGFloat)x Z:(CGFloat)z
{
    CGFloat y = z;
    CGFloat theta = x;
    
    CGFloat r = function(x,z);
    
    return SCNVector3Make(r*cosf(theta),
                          y,
                          r*sinf(theta));
}

@end
