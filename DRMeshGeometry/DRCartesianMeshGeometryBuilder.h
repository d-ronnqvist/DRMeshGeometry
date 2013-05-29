//
//  DRCartesianMeshGeometryBuilder.h
//  DRMeshGeometry
//
//  Created by David Rönnqvist on 5/29/13.
//  Copyright (c) 2013 David Rönnqvist. All rights reserved.
//

#import "DRMeshGeometryBuilder.h"

/**
 * Mesh function
 * -------------
 * The function:  y(x,z)  in a cartesian coordinate system
 */
typedef CGFloat(^DRCartesianMeshFunction)(CGFloat x, CGFloat z);


@interface DRCartesianMeshGeometryBuilder : DRMeshGeometryBuilder

/**
 * The x range & z range
 */
@property (assign) DRMeshRange xRange;
@property (assign) DRMeshRange zRange;

- (SCNGeometry *)geometryWithCartesianFunction:(DRCartesianMeshFunction)function;

@end
