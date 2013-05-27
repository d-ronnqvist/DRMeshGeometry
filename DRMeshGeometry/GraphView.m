//
//  GraphView.m
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

#import "GraphView.h"
#import "DRMeshGeometryBuilder.h"

@implementation GraphView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    // ==== SCENE CREATION ==== //
    
    // An empty scene
    SCNScene *scene = [SCNScene scene];
    self.scene = scene;
    
	// A camera
    // --------
    // The camera is moved back and up from the center of the scene
    // and then rotated so that it looks down to the center
	SCNNode *cameraNode = [SCNNode node];
	cameraNode.camera = [SCNCamera camera];
	cameraNode.position = SCNVector3Make(0, 15, 30);
    cameraNode.transform = CATransform3DRotate(cameraNode.transform,
                                               -M_PI/7.0,
                                               1, 0, 0);
    
    [scene.rootNode addChildNode:cameraNode];
	
    // Two soft directional lights
    // ------------
    // The spot light is positioned right next to the camera
    //    // so it is offset sligthly and added to the camera node
    SCNLight *dirLight = [SCNLight light];
    dirLight.type = SCNLightTypeDirectional;
    dirLight.color = [NSColor colorWithCalibratedWhite:0.5 alpha:1.0];
	SCNNode *dirLightNode = [SCNNode node];
	dirLightNode.light = dirLight;
    
   dirLightNode.transform = CATransform3DRotate(dirLightNode.transform, -M_PI_2, 1, 0, 0);
    
    
    SCNLight *dirLight2 = [SCNLight light];
    dirLight2.type = SCNLightTypeDirectional;
    dirLight2.color = [NSColor colorWithCalibratedWhite:0.5 alpha:1.0];
	SCNNode *dirLight2Node = [SCNNode node];
	dirLight2Node.light = dirLight2;

    [scene.rootNode addChildNode:dirLight2Node];
    
    [scene.rootNode addChildNode:dirLightNode];
    

    
    
    // Creating the geometry
    
    DRMeshGeometryBuilder *builder = [[DRMeshGeometryBuilder alloc] init];
    builder.numberOfTextureRepeats = DRMeshCountMake(10, 10);
    builder.xRange = DRMeshRangeMake(-20.0, 20.0);
    builder.zRange = DRMeshRangeMake(-20.0, 20.0);
    
    SCNGeometry *sine = [builder geometryWithFunction:^CGFloat(CGFloat x, CGFloat z) {
        return 2.0 * (sinf(.4*x) - cosf(.4*z));
    }];
    
    
    // Customizing it further with a texture
    
    sine.firstMaterial.diffuse.contents = [NSImage imageNamed:@"defaultGridTexture"];
    
    SCNNode *sineNode = [SCNNode nodeWithGeometry:sine];
    sineNode.position = SCNVector3Make(0, 0, 0);
    sineNode.scale = SCNVector3Make(.65, .65, .65);
   
    [scene.rootNode addChildNode:sineNode];
    

    
    
    
    // Rotating the mesh
    // -----------------
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    rotation.byValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI*2)];
    rotation.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotation.repeatCount = INFINITY;
    rotation.duration = 9.0;
   
    
    [sineNode addAnimation:rotation forKey:nil];
}

@end
