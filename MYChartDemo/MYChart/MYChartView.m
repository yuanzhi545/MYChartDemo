//
//  MYChartView.m
//  MYChartDemo
//
//  Created by yuan zhi on 3/26/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import "MYChartView.h"
@implementation MYChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _animationDuration = 1.0f;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
        _titleLabel.userInteractionEnabled = YES;
        [self addSubview:_titleLabel];
        
        _legendView = [[MYLegendView alloc] init];
        _legendView.legendFont = [UIFont fontWithName:@"Helvetica" size:14];
        _legendView.delegate = self;
        [self addSubview:_legendView];
        _legendView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setDataSource:(id<MYChartViewDataSource>)dataSource
{
    _dataSource = dataSource;
    _legendView.chartView = self;
}

- (void)reloadData
{

}

- (void)legendView:(MYLegendView *)legendView didSelectSection:(NSInteger)section
{
    
}

- (void)legendView:(MYLegendView *)legendView cancelSelectSection:(NSInteger)section
{
    
}

@end
