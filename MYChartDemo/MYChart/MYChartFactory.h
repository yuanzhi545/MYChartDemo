//
//  MYChartFactory.h
//  MYChartDemo
//
//  Created by yuan zhi on 3/26/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYChartView.h"

typedef enum {
    Pie_Chart,
    Column_Chart,
    Line_Chart
}ChartType;

@interface MYChartFactory : NSObject

+ (MYChartView *)createChartView:(ChartType)type;

@end
