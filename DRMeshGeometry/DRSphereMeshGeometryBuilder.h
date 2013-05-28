//
//  DRSphereMeshGeometryBuilder.h
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
typedef CGFloat(^DRSphereMeshFunction)(CGFloat theta, CGFloat psi);


@interface DRSphereMeshGeometryBuilder : DRMeshGeometryBuilder

/**
 * The theta range & psi range
 */
@property (assign) DRMeshRange thetaRange;
@property (assign) DRMeshRange psiRange;

- (SCNGeometry *)geometryWithSphereFunction:(DRSphereMeshFunction)function;

@end
