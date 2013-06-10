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
#import "DRCartesianMeshGeometryBuilder.h"
#import "DRCylinderMeshGeometryBuilder.h"
#import "DRSphereMeshGeometryBuilder.h"
#import <GLKit/GLKMath.h> // for the awsome matrix math

@interface GraphView (/*Private*/)

// Gesture handling
@property (assign) NSPoint previousPoint;

@property (weak) SCNNode *graphNode;

@end

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

#pragma mark - Scene creation

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
	cameraNode.position = SCNVector3Make(0, 0, 30);
    // To make rotating using the track pad feel more natural the camera is not
    // rotated, instead the geometry starts off with a slight tilt
    
    [scene.rootNode addChildNode:cameraNode];
	
    
    
    // Two soft directional lights
    // ---------------------------
    // To create a nice lighting effect that both lights the surface
    // and causes it to be shaded on the areas facing away from the
    // camera two directional lights are used: one facing down and
    // the other having the default (down along z tilt).
    // Since the object is lit by both lights they are not as strong.
    SCNLight *directionDownLight = [SCNLight light];
    directionDownLight.type = SCNLightTypeDirectional;
    directionDownLight.color = [NSColor colorWithCalibratedWhite:0.5 alpha:1.0];
	SCNNode *directionDownLightNode = [SCNNode node];
	directionDownLightNode.light = directionDownLight;
    
    directionDownLightNode.transform = CATransform3DRotate(directionDownLightNode.transform,
                                                           -M_PI_2, 1, 0, 0);
    
    
    SCNLight *directionForwardLight = [SCNLight light];
    directionForwardLight.type = SCNLightTypeDirectional;
    directionForwardLight.color = [NSColor colorWithCalibratedWhite:0.5 alpha:1.0];
	SCNNode *directionForwardLightNode = [SCNNode node];
	directionForwardLightNode.light = directionForwardLight;

    // The two lights are added to a node with a slight tilt to give
    // the illusion that the camera is tilted, not the geometry.
    SCNNode *lightNode = [SCNNode node];
    lightNode.transform = CATransform3DRotate(lightNode.transform,
                                              M_PI/7.0,
                                              1, 0, 0);
    
    [lightNode addChildNode:directionDownLightNode];
    [lightNode addChildNode:directionForwardLightNode];
    [scene.rootNode addChildNode:lightNode];

    
    
    // Creating the geometry
    // ---------------------
    // The geoemetry builder is used to generate a geometry of a
    // sine(x)-cos(z) curve (that looks like rounded hills).
    // The x and z ranges of the mesh are customized.
    
    
    DRCartesianMeshGeometryBuilder *builder = [[DRCartesianMeshGeometryBuilder alloc] init];
    builder.textureRepeatCounts = DRMeshCountMake(10, 10);
    builder.xRange = DRMeshRangeMake(-20.0, 20.0);
    builder.zRange = DRMeshRangeMake(-20.0, 20.0);
    
    SCNGeometry *sine = [builder geometryWithCartesianFunction:^CGFloat(CGFloat x, CGFloat z) {
        return 2.0 * (sinf(.4*x) - cosf(.4*z));
    }];

    SCNText *text = [SCNText textWithString:@"test" extrusionDepth:0];
    text.font = [NSFont systemFontOfSize:6];
        
//    DRCylinderMeshGeometryBuilder *cylinderBuilder = [[DRCylinderMeshGeometryBuilder alloc] init];
//    cylinderBuilder.thetaRange = DRMeshRangeMake(0, 2.0*M_PI);
//    cylinderBuilder.yRange = DRMeshRangeMake(-10.0, 10.0);
//    cylinderBuilder.textureRepeatCounts = DRMeshCountMake(25, 4);
//    
// SCNGeometry *sine = [cylinderBuilder geometryWithCylinderFunction:^CGFloat(CGFloat theta, CGFloat y) {
//        return 3.0*cosf(6.0*theta)+15.-0.5*y;
//    }];
    
//    DRSphereMeshGeometryBuilder *sphereBuilder = [[DRSphereMeshGeometryBuilder alloc] init];
//    sphereBuilder.thetaRange = DRMeshRangeMake(0, M_PI);
//    sphereBuilder.psiRange   = DRMeshRangeMake(-M_PI_2, 1.25*M_PI);
//    sphereBuilder.textureRepeatCounts = DRMeshCountMake(6, 6);
//    
//    SCNGeometry *sine = [sphereBuilder geometryWithSphereFunction:^CGFloat(CGFloat theta, CGFloat psi) {
//        return -5.0*psi + 0.5*sinf(theta*30.0);
//    }];
   

    
    // Customizing the mesh appearance with a texture
    sine.firstMaterial.diffuse.contents = [NSImage imageNamed:@"defaultGridTexture"];
    
    SCNNode *sineNode = [SCNNode nodeWithGeometry:sine];
    sineNode.name = @"sine";
    sineNode.position = SCNVector3Make(0, 0, 0);    // Position in the center (default) 
    sineNode.scale = SCNVector3Make(.65, .65, .65); // Scale the mesh to fit the screen.
   
    sineNode.transform = CATransform3DRotate(sineNode.transform,
                                             M_PI/7.0,
                                             1, 0, 0);
    
    [scene.rootNode addChildNode:sineNode];
    self.graphNode = sineNode;
    
    self.acceptsTouchEvents = YES;
}

#pragma mark - Gestures

#pragma mark Conveneice

/**
 * The average point for a set of touches.
 * Points that are resting doesn't count.
 */
- (NSPoint)averagePointForTouches:(NSSet *)touches
{
    CGFloat x = 0.0, y = 0.0;
    NSInteger count = 0;
    for (NSTouch *touch in touches) {
        if (!touch.isResting) {
            NSPoint point = touch.normalizedPosition;
            x+=point.x;
            y+=point.y;
            count++;
        }
    }
    x/=count;
    y/=count;
    
    NSTouch *anyTouch = [touches anyObject];
    NSSize size = anyTouch.deviceSize;
    x*=size.width;
    y*=size.height;
    
    return NSMakePoint(x, y);
}

/**
 * Rotates a given vector around the Euler axis of the transform.
 */
SCNVector3 rotatedVectorForTransform(SCNVector3 v, CATransform3D t)
{
    // Calculate the Euler angle and Euler axis fromt the transform
    CGFloat theta = acosf(0.5*(t.m11+t.m22+t.m33-1.0));
    if (isnan(theta)) theta = 0.0; // Make sure the angle is a number
    
    CGFloat ex = 0.0, ey = 1.0, ez = 0.0;
    if (fabsf(theta) > 0.0) {
        // Calculate the axis if there was an angle
        ex = -(t.m32-t.m23)/(2*sinf(theta));
        ey = -(t.m13-t.m31)/(2*sinf(theta));
        ez = -(t.m21-t.m12)/(2*sinf(theta));
        
        // Default to (0,1,0) is there was no axis
        if (fabsf(ex) < FLT_EPSILON &&
            fabsf(ey) < FLT_EPSILON &&
            fabsf(ez) < FLT_EPSILON) {
            ey = 1.;
        }
    }
    
    // Use the math from GLKit to rotate the vector
    GLKMatrix4 rotation = GLKMatrix4MakeRotation(-theta, ex, ey, ez);
    GLKVector3 axis = GLKVector3Make(v.x, v.y, v.z);
    
    GLKVector3 rotatedAxis = GLKMatrix4MultiplyVector3(rotation, axis);
 
    // Retirn the rotated axis as a SCNVector3
    return SCNVector3Make(rotatedAxis.x, rotatedAxis.y, rotatedAxis.z);
}

#pragma mark Zoom

- (void)magnifyWithEvent:(NSEvent *)event
{
    SCNNode *node = self.graphNode;
    CGFloat amount = event.magnification/2.+1.0;
    node.transform = CATransform3DScale(node.transform,
                                        amount, amount, amount);
}

#pragma mark Rotate

- (void)rotateWithEvent:(NSEvent *)event
{
    SCNNode *node = self.graphNode;
    
    SCNVector3 rot = rotatedVectorForTransform(SCNVector3Make(0, 0, 1), node.transform);
    
    node.transform = CATransform3DRotate(node.transform,
                                         event.rotation/25.,
                                         rot.x, rot.y, rot.z);
}

#pragma mark Pan

- (void)touchesBeganWithEvent:(NSEvent *)event {
    NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseTouching
                                          inView:self];
    
    self.previousPoint = [self averagePointForTouches:touches];
}

- (void)touchesMovedWithEvent:(NSEvent *)event
{
    NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseAny inView:self];
    
    NSPoint thisPoint = [self averagePointForTouches:touches];
    
    CGFloat dx = thisPoint.x - self.previousPoint.x;
    CGFloat dy = thisPoint.y - self.previousPoint.y;
    
    self.previousPoint = thisPoint;
    
    SCNNode *node = self.graphNode;
      
    if (touches.count == 2 && !NSEqualPoints(self.previousPoint, NSZeroPoint)) {
        
        if (fabsf(dx)>0 || fabsf(dy)>0) {
            
            CGFloat totalRotation = sqrt(dx * dx + dy * dy);
            
            SCNVector3 rot = rotatedVectorForTransform(SCNVector3Make(-dy, dx, 0), node.transform);
            
            node.transform = CATransform3DRotate(node.transform,
                                                 totalRotation * M_PI / 180.0,
                                                 rot.x, rot.y, rot.z);
        }
    }
    else {
        self.previousPoint = NSZeroPoint;
    }
}


- (void)touchesEndedWithEvent:(NSEvent *)event
{
    
}

- (void)touchesCancelledWithEvent:(NSEvent *)event
{
    
}





@end
