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

@interface GraphView (/*Touch handling*/) {
    NSTouch *_initialTouches[2];
    NSTouch *_previousTouches[2];
    NSTouch *_currentTouches[2];
    
}

@property (assign) NSPoint previousPoint;
@property (assign) BOOL isTracking;

@property (assign) CATransform3D previousTransform;

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
    
    directionDownLightNode.transform = CATransform3DRotate(directionDownLightNode.transform, -M_PI_2, 1, 0, 0);
    
    
    SCNLight *directionForwardLight = [SCNLight light];
    directionForwardLight.type = SCNLightTypeDirectional;
    directionForwardLight.color = [NSColor colorWithCalibratedWhite:0.5 alpha:1.0];
	SCNNode *directionForwardLightNode = [SCNNode node];
	directionForwardLightNode.light = directionForwardLight;

    [scene.rootNode addChildNode:directionDownLightNode];
    [scene.rootNode addChildNode:directionForwardLightNode];
    

    
    
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
    
    CATextLayer *textLayer = [CATextLayer layer];
//    textLayer.frame = CGRectMake(0, 0, 30, 15);
    textLayer.string = [[NSAttributedString alloc] initWithString:@"y kanske?"
                                                       attributes:@{NSForegroundColorAttributeName:[NSColor blackColor],NSBackgroundColorAttributeName:[NSColor whiteColor],
                                              NSFontAttributeName:[NSFont fontWithName:@"Avenir" size:72]}];
//    textLayer.font = CFBridgingRetain([NSFont fontWithName:@"Avenir" size:15].fontName);
//    textLayer.fontSize = 15;
//    textLayer.foregroundColor = [NSColor blueColor].CGColor;
//    textLayer.backgroundColor = [NSColor whiteColor].CGColor;
    CGSize textSize = [textLayer.string size];
    textLayer.frame = CGRectMake(0, 0, textSize.width, textSize.height);
//    textLayer.backgroundColor = [NSColor orangeColor].CGColor;
//    NSLabel *label = [[NSLabel alloc] init];
    
    [textLayer needsDisplay];
    [textLayer displayIfNeeded];
    
    SCNPlane *textPlane = [SCNPlane planeWithWidth:12 height:7];

    textPlane.firstMaterial.diffuse.contents = textLayer;
    textPlane.firstMaterial.locksAmbientWithDiffuse = YES;
    
    textPlane.firstMaterial.lightingModelName = SCNLightingModelConstant;
    
//    [self setWantsLayer:YES];
//    [self.layer addSublayer:textLayer];
    
    SCNNode *textNode = [SCNNode nodeWithGeometry:textPlane];
    textNode.position = SCNVector3Make(-22, 6, 22);
    
    // SCNBoundingVolume
    
    // SCNHitTestResult
    
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
   
    SCNBox *backgroundBox = [SCNBox boxWithWidth:45 height:25 length:45 chamferRadius:0];
//    backgroundBox.firstMaterial.transparency = 0.5;
    backgroundBox.firstMaterial.cullMode = SCNCullFront;
//    backgroundBox.firstMaterial.doubleSided = YES;
    
    
    // Customizing the mesh appearance with a texture
    sine.firstMaterial.diffuse.contents = [NSImage imageNamed:@"defaultGridTexture"];
    
    SCNNode *sineNode = [SCNNode nodeWithGeometry:sine];
    sineNode.name = @"sine";
    sineNode.position = SCNVector3Make(0, 0, 0);    // Position in the center (default) 
    sineNode.scale = SCNVector3Make(.65, .65, .65); // Scale the mesh to fit the screen.
   
    [scene.rootNode addChildNode:sineNode];
   
//    SCNNode *boxNode = [SCNNode nodeWithGeometry:backgroundBox];
//    [sineNode addChildNode:boxNode];
    
//    [sineNode addChildNode:textNode];
    
    CABasicAnimation *textRotation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    textRotation.byValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, -M_PI*2)];
    textRotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    textRotation.repeatCount = INFINITY;
    textRotation.duration = 9.0;
    
//    [textNode addAnimation:textRotation forKey:nil];
    
    
    
    
    
    // Rotating the mesh
    // -----------------
    // The mesh is given a slow linear full rotation around the Y axis.
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    rotation.byValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI*2)];
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotation.repeatCount = INFINITY;
    rotation.duration = 9.0;
   
//    [sineNode addAnimation:rotation forKey:nil];
    
    self.acceptsTouchEvents = YES;
}

- (void)touchesBeganWithEvent:(NSEvent *)event {
    NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseTouching
                                          inView:self];
    
    self.previousPoint = [self averagePointForTouches:touches];
    
//    if (touches.count == 2) {
//        self.initialPoint = [self convertPointFromBacking:[event locationInWindow]];
//        NSArray *array = [touches allObjects];
//        _previousTouches[0] = array[0];
//        _previousTouches[1] = array[1];
//        _currentTouches[0] = _previousTouches[0];
//        _currentTouches[1] = _previousTouches[1];
//    } else if (touches.count > 2) {
        // More than 2 touches. Only track 2.
//        if (self.isTracking) {
//            [self cancelTracking];
//        } else {
//            [self releaseTouches];
//        }
//    }
}


- (NSPoint)deltaOrigin {
    if (!(_previousTouches[0] && _previousTouches[1] &&
          _currentTouches[0] && _currentTouches[1])) return NSZeroPoint;
    
//    CGFloat x1 = MIN(_previousTouches[0].normalizedPosition.x, _previousTouches[1].normalizedPosition.x);
//    CGFloat x2 = MAX(_currentTouches[0].normalizedPosition.x, _currentTouches[1].normalizedPosition.x);
//    CGFloat y1 = MIN(_previousTouches[0].normalizedPosition.y, _previousTouches[1].normalizedPosition.y);
//    CGFloat y2 = MAX(_currentTouches[0].normalizedPosition.y, _currentTouches[1].normalizedPosition.y);
    
    CGFloat x1 = _previousTouches[0].normalizedPosition.x; 
    CGFloat x2 = _currentTouches[0].normalizedPosition.x;  
    CGFloat y1 = _previousTouches[0].normalizedPosition.y; 
    CGFloat y2 = _currentTouches[0].normalizedPosition.y;  
    
    NSSize deviceSize = _previousTouches[0].deviceSize;
    NSPoint delta;
    delta.x = (x2 - x1) * deviceSize.width;
    delta.y = (y2 - y1) * deviceSize.height;
    return delta;
}

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
    
    NSSize size = ((NSTouch *)[touches anyObject]).deviceSize;
    x*=size.width;
    y*=size.height;
    
    return NSMakePoint(x, y);
}

- (void)touchesMovedWithEvent:(NSEvent *)event {
//    return;
//    if (event.type == NSEventTypeRotate || event.type == NSEventTypeMagnify) return;
    
    
    
    
    
//    if (!self.isEnabled) return;
//    self.modifiers = [event modifierFlags];
    NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseAny inView:self];
    
    NSPoint thisPoint = [self averagePointForTouches:touches];
    
    CGFloat dx = thisPoint.x - self.previousPoint.x;
    CGFloat dy = thisPoint.y - self.previousPoint.y;
    
    self.previousPoint = thisPoint;
    
    SCNNode *node = [self.scene.rootNode childNodeWithName:@"sine" recursively:YES];
    
    self.previousTransform = node.transform;
//    
    if (touches.count == 2 && !NSEqualPoints(self.previousPoint, NSZeroPoint)) {

    
    NSPoint delta = NSMakePoint(dx, dy);//[self deltaOrigin];
//        delta.x = _currentTouches[0].x - _previousTouches[0].x;
//        delta.y = _currentTouches[0].y - _previousTouches[0].y;
        
//        SCNNode *node = [self.scene.rootNode childNodeWithName:@"sine" recursively:YES];
        
        
        CATransform3D currentTransform = node.transform;
        CGFloat displacementInX = delta.x/1.;//location.x - previousLocation.x;
        CGFloat displacementInY = -delta.y/1.;//previousLocation.y - location.y;
        
        if (fabsf(displacementInX)>0 || fabsf(displacementInY) > 0){
//
        CGFloat totalRotation = sqrt(displacementInX * displacementInX + displacementInY * displacementInY);
        
        CATransform3D rotationalTransform = CATransform3DRotate(currentTransform, totalRotation * M_PI / 180.0,
                                                                ((displacementInX/totalRotation) * currentTransform.m12 + (displacementInY/totalRotation) * currentTransform.m11),
                                                                ((displacementInX/totalRotation) * currentTransform.m22 + (displacementInY/totalRotation) * currentTransform.m21),
                                                                ((displacementInX/totalRotation) * currentTransform.m32 + (displacementInY/totalRotation) * currentTransform.m31));
        
        node.transform = rotationalTransform;
            CGFloat x, y;
            x = displacementInX;
            y = displacementInY;
//            node.transform = CATransform3DRotate(node.transform, M_PI/180.,
//                                                 y,//fabs(y)>fabs(x)?((y<0)?-1:1):0,
//                                                 x,//fabs(x)>fabs(y)?((x<0)?-1:1):0,
//                                                 0);
        }
//        node.transform = CATransform3DRotate(node.transform, M_PI/180., delta.y, delta.x, 0);

        
    }
}


- (void)touchesEndedWithEvent:(NSEvent *)event
{
    
    
//    if (!self.isEnabled) return;
//    self.modifiers = [event modifierFlags];
//    [self cancelTracking];
}

- (void)touchesCancelledWithEvent:(NSEvent *)event {
//    [self cancelTracking];
}

- (void)magnifyWithEvent:(NSEvent *)event
{
    SCNNode *node = [self.scene.rootNode childNodeWithName:@"sine" recursively:YES];
    CGFloat amount = event.magnification/2.+1.0;
    node.transform = CATransform3DScale(node.transform,
                                        amount, amount, amount);
}

SCNVector3 crossProduct(SCNVector3 a, SCNVector3 b);
SCNVector3 normalize(SCNVector3 v);

- (void)rotateWithEvent:(NSEvent *)event
{
    SCNNode *node = [self.scene.rootNode childNodeWithName:@"sine" recursively:YES];
    
    
    CATransform3D t = node.transform;
    
//    CGFloat phi, thet, psi;
//    phi = atan2f(t.m31, t.m32);
    
//    GLKMatrix4 rotation = glk;
    
    
    CGFloat theta = acosf(0.5*(t.m11+t.m22+t.m33-1.0));
    
    if (isnan(theta)) theta = 0.0;
//    theta = 1.0;
    SCNVector3 e = SCNVector3Make(0, 1, 0);
    CGFloat ex, ey, ez;
    ex = ez = 0.;
    ey = 1.;
    if (fabsf(theta)>0.) {
//        ex = (t.m32-t.m23)/(2*sinf(theta));
//        ey = (t.m13-t.m31)/(2*sinf(theta));
//        ez = (t.m21-t.m12)/(2*sinf(theta));
        
        ex = -(t.m32-t.m23)/(2*sinf(theta));
        ey = -(t.m13-t.m31)/(2*sinf(theta));
        ez = -(t.m21-t.m12)/(2*sinf(theta));
        
        
        e = SCNVector3Make(ex, ey, ez);
    }
    
    GLKMatrix4 rotation = GLKMatrix4MakeRotation(-theta, ex, ey, ez);
    GLKVector3 axis = GLKVector3Make(0, 0, 1);
    
    GLKVector3 rotatedAxis = GLKMatrix4MultiplyVector3(rotation, axis);
    
//    NSLog(@"\n| %6.3f %6.3f %6.3f %6.3f |\n| %6.3f %6.3f %6.3f %6.3f |\n| %6.3f %6.3f %6.3f %6.3f |\n| %6.3f %6.3f %6.3f %6.3f |\n\n",
//          t.m11, t.m12, t.m13, t.m14,
//          t.m21, t.m22, t.m23, t.m24,
//          t.m31, t.m32, t.m33, t.m34,
//          t.m41, t.m42, t.m43, t.m44);
    
//    NSLog(@"EIGEN:\n Θ:%6.3f x:%6.3f y:%6.3f z:%6.3f",
//          theta, ex, ey, ez);
    
    
//    SCNVector3 rot = normalize( crossProduct(SCNVector3Make(0, 0.5, -1.0), e) );
    
    SCNVector3 rot = SCNVector3Make(rotatedAxis.x, rotatedAxis.y, rotatedAxis.z);
    
//    NSLog(@"ROT:\n x:%6.3f y:%6.3f z:%6.3f",
//          rot.x, rot.y, rot.z);
    
    node.transform = CATransform3DRotate(node.transform,
                                         event.rotation/25.,
                                         rot.x, rot.y, rot.z);
}



//- (void)beginGestureWithEvent:(NSEvent *)event
//{
//    NSSet *touches 
//}
//
//- (void)endGestureWithEvent:(NSEvent *)event
//{
//    
//}

//-(NSSet *)touchesMatchingPhase:(NSTouchPhase)phase inView:(NSView *)view;




@end
