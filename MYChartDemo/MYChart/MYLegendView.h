//
//  MYLegendView.h
//  MYChartDemo
//
//  Created by yuan zhi on 4/11/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MYLegendBottom,
    MYLegendRight,
    MYLegendTop,
    MYLegendLeft
}MYLegendPosition;

@protocol MYLegendDelegate;

@class MYChartView;
@interface MYLegendView : UIView
@property (nonatomic, weak) id<MYLegendDelegate> delegate;
@property (nonatomic, strong) UIFont *legendFont;
@property (nonatomic, weak) MYChartView *chartView;
@property (nonatomic, strong) NSMutableArray *legendStateArray;

- (CGRect)legendFrameWithPosition:(MYLegendPosition)position;
@end


@protocol MYLegendDelegate <NSObject>

- (void)legendView:(MYLegendView *)legendView didSelectSection:(NSInteger)section;

- (void)legendView:(MYLegendView *)legendView cancelSelectSection:(NSInteger)section;

@end