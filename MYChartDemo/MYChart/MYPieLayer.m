//
//  MYPieLayer.m
//  MYChartDemo
//
//  Created by yuan zhi on 3/26/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import "MYPieLayer.h"

typedef enum {
    MYPieLayerSlices,
    MYPieLayerLabels
} MYPieLayerGroup;

@implementation MYPieLayer
- (id)init
{
    self = [super init];
    if (self) {
        [self setContentsScale:[[UIScreen mainScreen] scale]];
        [self addSublayer:[CALayer layer]];
        [self addSublayer:[CALayer layer]];
        [self addSublayer:[CALayer layer]];
        
        [[self sublayers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj setContentsScale:[[UIScreen mainScreen] scale]];
        }];
    }
    return self;
}

- (CALayer *)sliceLayers
{
    return [[self sublayers] objectAtIndex:MYPieLayerSlices];
}

- (CALayer *)labelLayers
{
    return [[self sublayers] objectAtIndex:MYPieLayerLabels];
}

- (void)removeAllPieLayers
{
    [[[self sliceLayers] sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [[[self labelLayers] sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}
@end
