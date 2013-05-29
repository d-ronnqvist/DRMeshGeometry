DRMeshGeometry v0.2.1
==============

DRMeshGeometryBuilder is a builder of static mesh geometry that makes it really easy to do 3D graphs in SceneKit.

![An example rendering of a mesh](example.png)

The above geometry was generated with this code (available in the sampe project)

    DRCartesianMeshGeometryBuilder *builder = [[DRCartesianMeshGeometryBuilder alloc] init];
    builder.textureRepeatCounts = DRMeshCountMake(10, 10);
    builder.xRange = DRMeshRangeMake(-20.0, 20.0);
    builder.zRange = DRMeshRangeMake(-20.0, 20.0);
    
    SCNGeometry *sine = [builder geometryWithCartesianFunction:^CGFloat(CGFloat x, CGFloat z) {
        return 2.0 * (sinf(.4*x) - cosf(.4*z));
    }];


Once the geometry is generated it can be shaded using any light and material just like normal geometry in the scene.

![Another shading of a sample mesh](light.png)

##  Other coordinate systems

There is also similar builders to construct both **cylindrical** and **spherical** meshes, as seen below.

The following code generates the *cylindrical* mesh seen below

    DRCylinderMeshGeometryBuilder *cylinderBuilder = [[DRCylinderMeshGeometryBuilder alloc] init];
    cylinderBuilder.thetaRange = DRMeshRangeMake(0, 2.0*M_PI);
    cylinderBuilder.yRange = DRMeshRangeMake(-10.0, 10.0);
    cylinderBuilder.textureRepeatCounts = DRMeshCountMake(25, 4);
    
    SCNGeometry *sine = [cylinderBuilder geometryWithCylinderFunction:^CGFloat(CGFloat theta, CGFloat y) {
        return 3.0*cosf(6.0*theta)+15.-0.5*y;
    }];

![An example rendering of a cylindric mesh](cylinder.png)

In the same manner, this code generates the *spherical* mesh seen below

    DRSphereMeshGeometryBuilder *sphereBuilder = [[DRSphereMeshGeometryBuilder alloc] init];
    sphereBuilder.thetaRange = DRMeshRangeMake(0, M_PI);
    sphereBuilder.psiRange   = DRMeshRangeMake(-M_PI_2, 1.25*M_PI);
    sphereBuilder.textureRepeatCounts = DRMeshCountMake(6, 6);
    
    SCNGeometry *sine = [sphereBuilder geometryWithSphereFunction:^CGFloat(CGFloat theta, CGFloat psi) {
        return -5.0*psi + 0.5*sinf(theta*30.0);
    }];
 
 ![An example rendering of a sphere mesh](sphere.png)
 
  
# Known limitations

 * Currently only supports continous geometry. 

If you need this or another addition or find a bug, please [file an issue](https://github.com/d-ronnqvist/DRMeshGeometry/issues).

# Future ideas

I’m also thinking of making the graph view into a component with properties for showing the axis and allowing the user to pan around.

-----------------

# New in v0.2

 * Spherical and cylindrical mesh builders.
