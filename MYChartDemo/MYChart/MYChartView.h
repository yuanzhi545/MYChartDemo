//
//  MYChartView.h
//  MYChartDemo
//
//  Created by yuan zhi on 3/26/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYLegendView.h"

#define kTitleHeight 40

@protocol MYChartViewDelegate;
@protocol MYChartViewDataSource;

@interface MYChartView : UIView<MYLegendDelegate>
@property (nonatomic, strong) MYLegendView *legendView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, weak) id <MYChartViewDataSource> dataSource;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) MYLegendPosition legendPosition;
- (void)reloadData;

@end


@protocol MYChartViewDataSource <NSObject>

- (NSInteger)numberOfSectionsInChartView:(MYChartView *)chartView;

- (NSInteger)chartView:(MYChartView *)chartView numberOfRowsInSection:(NSUInteger)section;

- (NSString *)chartView:(MYChartView *)chartView displayValueForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSNumber *)chartView:(MYChartView *)chartView valueForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)chartView:(MYChartView *)chartView legendTitleImSection:(NSUInteger)section;

- (UIColor *)chartView:(MYChartView *)chartView colorInSection:(NSUInteger)section;

@optional

- (NSInteger)numberOfLineSectionsInChartView:(MYChartView *)chartView;

- (NSString *)chartView:(MYChartView *)tableView titleForFooterInRow:(NSUInteger)row;

@end