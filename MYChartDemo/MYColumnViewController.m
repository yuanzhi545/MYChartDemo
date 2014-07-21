//
//  MYColumnViewController.m
//  MYChartDemo
//
//  Created by yuan zhi on 7/7/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import "MYColumnViewController.h"
#import "MYChartFactory.h"

@interface MYColumnViewController ()<MYChartViewDataSource>

@end

@implementation MYColumnViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    MYChartView *chartView = [MYChartFactory createChartView:Column_Chart];
    [self.view addSubview:chartView];
    self.view.backgroundColor = [UIColor colorWithWhite:250/255.0f alpha:1.0f];
    chartView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 100);
    chartView.dataSource = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [chartView reloadData];
    });
}

#pragma mark - MYChartViewDataSource

- (NSInteger)numberOfSectionsInChartView:(MYChartView *)chartView
{
    return 2;
}

- (NSInteger)numberOfLineSectionsInChartView:(MYChartView *)chartView
{
    return 1;
}

- (NSInteger)chartView:(MYChartView *)chartView numberOfRowsInSection:(NSUInteger)section
{
    return 5;
}

- (NSString *)chartView:(MYChartView *)chartView displayValueForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"This is (%d,%d)",(int)indexPath.section,(int)indexPath.row];
}

- (NSNumber *)chartView:(MYChartView *)chartView valueForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return [NSNumber numberWithDouble:500];
            case 1:
                return [NSNumber numberWithDouble:-150];
            case 2:
                return [NSNumber numberWithDouble:400];
            default:
                return [NSNumber numberWithDouble:300];
        }
    }
    else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                return [NSNumber numberWithDouble:100];
            case 1:
                return [NSNumber numberWithDouble:150];
            case 2:
                return [NSNumber numberWithDouble:-200];
            default:
                return [NSNumber numberWithDouble:200];
        }
    }
    else
    {
        switch (indexPath.row) {
            case 0:
                return [NSNumber numberWithDouble:0.4];
            case 1:
                return [NSNumber numberWithDouble:-0.2];
            case 2:
                return [NSNumber numberWithDouble:0.6];
            default:
                return [NSNumber numberWithDouble:0.2];
        }
    }
    
}

- (NSString *)chartView:(MYChartView *)chartView legendTitleImSection:(NSUInteger)section
{
    switch (section) {
        case 0:
            return @"华南区域";
        case 1:
            return @"华北区域";
        case 2:
            return @"销售增长率";
        case 3:
            return @"华中区域";
        case 4:
            return @"西南区域";
        default:
            return @"区域";
    }
}

- (UIColor *)chartView:(MYChartView *)chartView colorInSection:(NSUInteger)section
{
    switch (section) {
        case 0:
            return [UIColor purpleColor];
        case 1:
            return [UIColor orangeColor];
        case 2:
            return [UIColor redColor];
        case 3:
            return [UIColor blueColor];
        case 4:
            return [UIColor greenColor];
        default:
            return [UIColor brownColor];
    }
}

- (NSString *)chartView:(MYChartView *)tableView titleForFooterInRow:(NSUInteger)row
{
    switch (row) {
        case 0:
            return @"一月份";
        case 1:
            return @"二月份";
        case 2:
            return @"三月份";
        case 3:
            return @"四月份";
        case 4:
            return @"五月份";
        default:
            return @"月份";
    }
}
@end
