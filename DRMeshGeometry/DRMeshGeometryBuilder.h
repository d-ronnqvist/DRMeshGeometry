//
//  DRMeshGeometryBuilder.h
//  DRMeshGeometry
//
//  Created by David Rönnqvist on 5/26/13.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in the
// Software without restriction, including without limitation the rights to use, copy,
// modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

/**
 * A range from a minimum value to a maximum value
 */
typedef struct {
    CGFloat min;
    CGFloat max;
} DRMeshRange;

/** 
 * A positive count with the x and z values 
 */
typedef struct {
    NSUInteger x;
    NSUInteger z;
} DRMeshCount;

/**
 * Mesh function
 * -------------
 * The function:  y(x,z)  in a cartesian coordinate system
 */
typedef CGFloat(^DRMeshFunction)(CGFloat x, CGFloat z);


/**
 * @class DRMeshGeometryBuilder
 * 
 * Creates a mesh geometry for a range of x,z values using
 * a DRMeshFunction to calculate the y value for each point.
 */
@interface DRMeshGeometryBuilder : NSObject

/**
 * The x range & z range
 */
@property (assign) DRMeshRange xRange;
@property (assign) DRMeshRange zRange;

/**
 * The number of times the texture repeat for x & z.
 * (Default is 1 for both directions)
 */
@property (assign) DRMeshCount numberOfTextureRepeats;

/**
 * The number of sub elements for x & z.
 * (Default is 100 for both directions)
 */
@property (assign) DRMeshCount numberOfStepsPerAxis;

/**
 * @method geometryWithFunction:
 * @param function  The function used to calculate the y(x,z)
 *
 * Generates a new geometry object for the configured ranges
 * and the function passed as the argument.
 *
 * The geometry comes with a basic material.
 */
- (SCNGeometry *)geometryWithFunction:(DRMeshFunction)function;

@end

/**
 * Creates a DRMeshRange between min and max.
 */
NS_INLINE DRMeshRange DRMeshRangeMake(CGFloat min, CGFloat max) {
    DRMeshRange r;
    r.min = min;
    r.max = max;
    return r;
}

/**
 * Creates a DRMeshCount for x and z.
 */
NS_INLINE DRMeshCount DRMeshCountMake(NSUInteger x, NSUInteger z) {
    DRMeshCount c;
    c.x = x;
    c.z = z;
    return c;
}
