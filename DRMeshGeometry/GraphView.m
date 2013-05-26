//
//  GraphView.m
//  DRMeshGeometry
//
//  Created by David Rönnqvist on 5/26/13.
//  Copyright (c) 2013 David Rönnqvist. All rights reserved.
//

#import "GraphView.h"

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
}

@end
