//
//  MYColumnView.h
//  MYChartDemo
//
//  Created by yuan zhi on 3/27/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import "MYChartView.h"
#import "MYColumnBgLayer.h"

#define kBarMinWidth 30
#define kBarMaxWidth 50

#define kBarPadding  15

#define kBottomHeight 20

@interface MYColumnBarView : MYChartView
{
    CGFloat barWidth;
    CGFloat barPadding;
    
    CGFloat leftAxisWidth;
    CGFloat rightAxisWidth;
    
    CGRect canvasFrame;
    CGFloat stepHeight;
    
    CGFloat leftYAxisZeroHeight;
    CGFloat rightYAxisZeroHeight;
    
    int leftStep;
    int rightStep;
    
    MYColumnBgLayer *bgLayer;
    
    UIScrollView *mScrollView;
    
    UIView *tipView;
}
@property (nonatomic, strong) UIFont *axisFont;
@end
