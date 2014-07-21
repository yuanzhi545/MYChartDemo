//
//  MYChartFactory.m
//  MYChartDemo
//
//  Created by yuan zhi on 3/26/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import "MYChartFactory.h"

@implementation MYChartFactory

+ (MYChartView *)createChartView:(ChartType)type
{
    switch (type) {
        case Pie_Chart:
            return [[NSClassFromString(@"MYPieView") alloc] init];
        case Column_Chart:
            return [[NSClassFromString(@"MYColumnBarView") alloc] init];
        default:
            return nil;
    }
    return nil;
}
@end
