//
//  MYBarView.h
//  MYChartDemo
//
//  Created by yuan zhi on 7/9/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYBarChartView : UIView
@property (nonatomic, strong) CAShapeLayer *barLayer;
/**
 *  是否是正值
 */
@property (nonatomic, assign) BOOL isPositive;
@end
