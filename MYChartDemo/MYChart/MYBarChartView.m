//
//  MYBarView.m
//  MYChartDemo
//
//  Created by yuan zhi on 7/9/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import "MYBarChartView.h"

@implementation MYBarChartView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.barLayer = [CAShapeLayer layer];
        _barLayer.lineCap = kCALineCapSquare;
        [self.layer addSublayer:self.barLayer];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _barLayer.lineWidth = self.frame.size.width;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.frame.size.width/2.0f,self.isPositive?self.frame.size.height:0);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width/2.0f, self.isPositive?0:self.frame.size.height);
    self.barLayer.path = path;
    CFRelease(path);
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.5f;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [self.barLayer addAnimation:pathAnimation forKey:nil];
}

@end
