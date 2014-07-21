//
//  MYSliceLayer.m
//  MYChartDemo
//
//  Created by yuan zhi on 3/26/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import "MYSliceLayer.h"

@implementation MYSliceLayer
@dynamic sliceAngle;

+ (id)layerWithColor:(CGColorRef)fillColor
{
    MYSliceLayer *sliceLayer = [MYSliceLayer layer];
    [sliceLayer setFillColor:fillColor];
    [sliceLayer setStrokeColor:[UIColor colorWithWhite:0.8 alpha:1].CGColor];
    [sliceLayer setLineWidth:0.5f];
    [sliceLayer setContentsScale:[[UIScreen mainScreen] scale]];
    
    return sliceLayer;
}
@end
