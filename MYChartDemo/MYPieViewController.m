//
//  ViewController.m
//  MYChartDemo
//
//  Created by yuan zhi on 3/26/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import "MYPieViewController.h"
#import "MYChartFactory.h"

@interface MYPieViewController ()<MYChartViewDataSource>

@end

@implementation MYPieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    MYChartView *chartView = [MYChartFactory createChartView:Pie_Chart];
    [self.view addSubview:chartView];
    self.view.backgroundColor = [UIColor colorWithWhite:250/255.0f alpha:1.0f];
    chartView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 200);
    chartView.dataSource = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [chartView reloadData];
    });
    
}

#pragma mark - MYChartViewDataSource

- (NSInteger)numberOfSectionsInChartView:(MYChartView *)chartView
{
    return 5;
}

- (NSInteger)chartView:(MYChartView *)chartView numberOfRowsInSection:(NSUInteger)section
{
    return 1;
}

- (NSString *)chartView:(MYChartView *)chartView displayValueForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"This is %d",(int)indexPath.section];
}

- (NSNumber *)chartView:(MYChartView *)chartView valueForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NSNumber numberWithDouble:indexPath.section * 10 + 10];
}

- (NSString *)chartView:(MYChartView *)chartView legendTitleImSection:(NSUInteger)section
{
    switch (section) {
        case 0:
            return @"华南区域";
        case 1:
            return @"华北区域";
        case 2:
            return @"西北区域";
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
            return [UIColor greenColor];
        case 3:
            return [UIColor blueColor];
        case 4:
            return [UIColor brownColor];
        default:
            return [UIColor redColor];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end