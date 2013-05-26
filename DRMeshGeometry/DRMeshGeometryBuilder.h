//
//  DRMeshGeometryBuilder.h
//  DRMeshGeometry
//
//  Created by David Rönnqvist on 5/26/13.
//  Copyright (c) 2013 David Rönnqvist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

typedef struct {
    CGFloat min;
    CGFloat max;
} DRMeshRange;

typedef struct {
    NSUInteger x;
    NSUInteger z;
} DRMeshCount;

// Think of it as: y(x,z)
typedef CGFloat(^DRMeshFunction)(CGFloat x, CGFloat z);

@interface DRMeshGeometryBuilder : NSObject

// Repeat from -1 to 1
@property (assign) DRMeshRange xRange;
@property (assign) DRMeshRange zRange;

//@property (copy) DRMeshFunction valueFunction;

// 1 x 1  = texture spans the corners
@property (assign) DRMeshCount numberOfTextureRepeats; 

// 100 x 100 by default 
@property (assign) DRMeshCount numberOfStepsPerAxis;

- (SCNGeometry *)geometryWithFunction:(DRMeshFunction)function;

@end

NS_INLINE DRMeshRange DRMeshRangeMake(CGFloat min, CGFloat max) {
    DRMeshRange r;
    r.min = min;
    r.max = max;
    return r;
}

NS_INLINE DRMeshCount DRMeshCountMake(NSUInteger x, NSUInteger z) {
    DRMeshCount c;
    c.x = x;
    c.z = z;
    return c;
}
