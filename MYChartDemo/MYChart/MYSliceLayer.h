//
//  MYSliceLayer.h
//  MYChartDemo
//
//  Created by yuan zhi on 3/26/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>


@interface MYSliceLayer : CAShapeLayer
@property (nonatomic, assign) CGFloat sliceAngle;

+ (id)layerWithColor:(CGColorRef)fillColor;
@end
