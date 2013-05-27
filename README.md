DRMeshGeometry
==============

DRMeshGeometryBuilder is a builder of static mesh geometry that makes it really easy to do 3D graphs in SceneKit.



The above geometry was generated with this code (available in the sampe project)

    DRMeshGeometryBuilder *builder = [[DRMeshGeometryBuilder alloc] init];
    builder.numberOfTextureRepeats = DRMeshCountMake(10, 10);
    builder.xRange = DRMeshRangeMake(-20.0, 20.0);
    builder.zRange = DRMeshRangeMake(-20.0, 20.0);
    
    SCNGeometry *sine = [builder geometryWithFunction:^CGFloat(CGFloat x, CGFloat z) {
        return 2.0 * (sinf(.4*x) - cosf(.4*z));
    }];

# Known limitations 

 * Only supports continous geometry. 
 * Only cartesian coordinate systems (x,y,z).
 
If you need these additions or find a bug, please file an issue.
