//
//  MYPieLayer.h
//  MYChartDemo
//
//  Created by yuan zhi on 3/26/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface MYPieLayer : CALayer

- (CALayer *)sliceLayers;

- (CALayer *)labelLayers;

- (void)removeAllPieLayers;

@end
