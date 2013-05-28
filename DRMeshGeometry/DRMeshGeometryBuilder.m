//
//  DRMeshGeometryBuilder.m
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

#import "DRMeshGeometryBuilder.h"

@interface DRMeshGeometryBuilder (/*Private*/)

@property (copy) DRMeshFunction function;

@end


@implementation DRMeshGeometryBuilder

#pragma mark - Generating geometry
- (id)init
{
    self = [super init];
    if (self) {
        _xRange = DRMeshRangeMake(-1.0, 1.0);
        _zRange = DRMeshRangeMake(-1.0, 1.0);
        
        _numberOfStepsPerAxis = DRMeshCountMake(100, 100);
        _numberOfTextureRepeats = DRMeshCountMake(1, 1);

    }
    return self;
}

- (SCNGeometry *)geometryWithFunction:(DRMeshFunction)function
{
    self.function = function;
    
    NSUInteger width = self.numberOfStepsPerAxis.x;
    NSUInteger depth = self.numberOfStepsPerAxis.z;
    
    NSUInteger pointCount = width * depth;
    
    SCNVector3  vertices[pointCount];
    SCNVector3  normals[pointCount];
    CGPoint     textures[pointCount];
    
    
    NSUInteger numberOfIndices = (2*width)*(depth);
    if (depth%4==0) numberOfIndices += 2;
    
    short indices[numberOfIndices];

    
//    The indices for a mesh
//
//    (1)━━━(2)━━━(3)━━━(4)
//     ┃   ◥ ┃   ◥ ┃   ◥ ┃
//     ┃  ╱  ┃  ╱  ┃  ╱  ┃
//     ▼ ╱   ▼ ╱   ▼ ╱   ▼  
//    (4)━━━(5)━━━(6)━━━(7)⟳  nr 7 twice
//     ┃ ◤   ┃ ◤   ┃ ◤   ┃
//     ┃  ╲  ┃  ╲  ┃  ╲  ┃
//     ┃   ╲ ┃   ╲ ┃   ╲ ┃
//  ⟳(8)━━━(9)━━━(10)━━(11)   nr 8 twice
//     ┃   ◥ ┃   ◥ ┃   ◥ ┃
//     ┃  ╱  ┃  ╱  ┃  ╱  ┃
//     ▼ ╱   ▼ ╱   ▼ ╱   ▼
//    (12)━━(13)━━(14)━━(15)
    
    short lastIndex = 0;
    for (int row = 0 ; row<width-1 ; row++) {
        BOOL isEven = row%2 == 0;
        for (int col = 0 ; col<depth ; col++) {
            
            if (isEven) {
                indices[lastIndex] = row*width + col;
                lastIndex++;
                indices[lastIndex] = (row+1)*width + col;
                if (col == depth-1) {
                    lastIndex++;
                    indices[lastIndex] = (row+1)*width + col;
                }
            } else {
                indices[lastIndex] = row*width + (depth-1-col);
                lastIndex++;
                indices[lastIndex] = (row+1)*width + (depth-1-col);
                if (col == depth-1) {
                    lastIndex++;
                    indices[lastIndex] = (row+1)*width + (depth-1-col);
                }
            }
            lastIndex++;
        }
    }
    
    
    // Generate the mesh by calculating the vector, normal
    // and texture coordinate for each x,z pair.
    
    for (int row = 0 ; row<width ; row++) {
        for (int col = 0 ; col<depth ; col++) {
  
            CGFloat x = (float)col/width * (self.xRange.max - self.xRange.min) + self.xRange.min;
            CGFloat z = (float)row/depth * (self.zRange.max - self.zRange.min) + self.zRange.min;
            
            SCNVector3 value =  SCNVector3Make(x,
                                           function(x, z),
                                           z);
            
            vertices[col + row*depth] = value;
            
            CGFloat delta = 0.001;
            SCNVector3 dx = vectorSubtract(value,
                                           SCNVector3Make(x + delta,
                                                          function(x + delta, z),
                                                          z));
            SCNVector3 dz = vectorSubtract(value,
                                           SCNVector3Make(x,
                                                          function(x, z+ delta),
                                                          z+ delta));
            
 
            normals[col + row*depth] = normalize( crossProduct(dz, dx) );
            
            
            textures[col + row*depth] = CGPointMake(col/(float)width*self.numberOfTextureRepeats.x,
                                                    row/(float)depth*self.numberOfTextureRepeats.z);
            
        }
    }
    
    // Create geometry sources for the generated data
    
    SCNGeometrySource *vertexSource  = [SCNGeometrySource geometrySourceWithVertices:vertices           count:pointCount];
    SCNGeometrySource *normalSource  = [SCNGeometrySource geometrySourceWithNormals:normals             count:pointCount];
    SCNGeometrySource *textureSource = [SCNGeometrySource geometrySourceWithTextureCoordinates:textures count:pointCount];
    
    
    // Configure the indices that was to be interpreted as a
    // triangle strip using
    
    SCNGeometryElement *element =
    [SCNGeometryElement geometryElementWithData:[NSData dataWithBytes:indices
                                                               length:sizeof(short[numberOfIndices])]
                                  primitiveType:SCNGeometryPrimitiveTypeTriangleStrip
                                 primitiveCount:numberOfIndices
                                  bytesPerIndex:sizeof(short)];
    
    // Create geometry from these sources
    
    SCNGeometry *geometry = [SCNGeometry geometryWithSources:@[vertexSource, normalSource, textureSource]
                                                elements:@[element]];
    
    // Since the builder exposes a geometry with repeating texture 
    // coordinates it is configured with a repeating material
    
    SCNMaterial *repeatingTextureMaterial = [SCNMaterial material];
    repeatingTextureMaterial.doubleSided = YES;
    
    repeatingTextureMaterial.diffuse.wrapS = SCNRepeat;
    repeatingTextureMaterial.diffuse.wrapT = SCNRepeat;
    
    repeatingTextureMaterial.ambient.wrapS = SCNRepeat;
    repeatingTextureMaterial.ambient.wrapT = SCNRepeat;
    
    // Possibly repeat all the materials texture coordintes here
    
    repeatingTextureMaterial.specular.contents = [NSColor colorWithCalibratedWhite:0.3 alpha:1.0];
    repeatingTextureMaterial.shininess = .1250;
    
        
    geometry.materials = @[repeatingTextureMaterial];
    
    return geometry;
}


#pragma mark - Vector math

SCNVector3 crossProduct(SCNVector3 a, SCNVector3 b)
{
	return SCNVector3Make(a.y*b.z - a.z*b.y, a.z*b.x - a.x*b.z, a.x*b.y - a.y*b.x);
}

SCNVector3 normalize(SCNVector3 v)
{
    CGFloat len = sqrt(pow(v.x, 2) + pow(v.y, 2) + pow(v.z, 2));
    
	return SCNVector3Make(v.x/len, v.y/len, v.z/len);
}

SCNVector3 vectorSubtract(SCNVector3 a, SCNVector3 b)
{
    return SCNVector3Make(a.x-b.x, a.y-b.y, a.z-b.z);
}

@end
