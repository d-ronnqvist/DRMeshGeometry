//
//  DRCylinderMeshGeometryBuilder.h
//  DRMeshGeometry
//
//  Created by David Rönnqvist on 5/28/13.
//  Copyright (c) 2013 David Rönnqvist. All rights reserved.
//

#import "DRMeshGeometryBuilder.h"

/**
 * Mesh function
 * -------------
 * The function:  r(theta,y)  in a cylindric coordinate system
 */
typedef CGFloat(^DRCylinderMeshFunction)(CGFloat theta, CGFloat y);


@interface DRCylinderMeshGeometryBuilder : DRMeshGeometryBuilder

/**
 * The theta range & y range
 */
@property (assign) DRMeshRange thetaRange;
@property (assign) DRMeshRange yRange;

- (SCNGeometry *)geometryWithCylinderFunction:(DRCylinderMeshFunction)function;


@end
