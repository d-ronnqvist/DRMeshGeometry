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
