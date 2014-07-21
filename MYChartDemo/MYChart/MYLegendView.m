//
//  MYLegendView.m
//  MYChartDemo
//
//  Created by yuan zhi on 4/11/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import "MYLegendView.h"
#import "MYChartView.h"

#define kLegendPadding 10
#define kLegendWidth 20

@implementation MYLegendView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLegend:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)setChartView:(MYChartView *)chartView
{
    _chartView = chartView;
    self.legendStateArray = [NSMutableArray array];
    int sectionCount = [chartView.dataSource numberOfSectionsInChartView:chartView];
    if ([chartView.dataSource respondsToSelector:@selector(numberOfLineSectionsInChartView:)]) {
        sectionCount += [chartView.dataSource numberOfLineSectionsInChartView:chartView];
    }
    for (int i = 0; i < sectionCount; i++) {
        [self.legendStateArray addObject:[NSNumber numberWithBool:NO]];
    }
}

- (void)tapLegend:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        int lineCount = floor(self.frame.size.width/100);
        
        CGPoint point = [gesture locationInView:self];
        int yIndex = floor((point.y - 5)/20);
        int xIndex = floor(point.x - 5)/103;
        
        int sectionCount = [self.chartView.dataSource numberOfSectionsInChartView:self.chartView];
        if (yIndex < 0 || yIndex > sectionCount/lineCount || xIndex < 0 || xIndex > lineCount) {
            return;
        }
        
        int selectIndex = yIndex*lineCount + xIndex;
        if (selectIndex >= self.legendStateArray.count) {
            return;
        }
        if ([[self.legendStateArray objectAtIndex:selectIndex] boolValue]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(legendView:cancelSelectSection:)]) {
                [self.delegate legendView:self cancelSelectSection:selectIndex];
            }
            [self.legendStateArray replaceObjectAtIndex:selectIndex withObject:[NSNumber numberWithBool:NO]];
        }
        else if (self.delegate && [self.delegate respondsToSelector:@selector(legendView:didSelectSection:)]) {
            [self.delegate legendView:self didSelectSection:selectIndex];
            [self.legendStateArray replaceObjectAtIndex:selectIndex withObject:[NSNumber numberWithBool:YES]];
        }
        [self setNeedsDisplay];
    }
}


- (CGSize)totalSize
{
    int sectionCount = [self.chartView.dataSource numberOfSectionsInChartView:self.chartView];
    if ([self.chartView.dataSource respondsToSelector:@selector(numberOfLineSectionsInChartView:)]) {
        sectionCount += [self.chartView.dataSource numberOfLineSectionsInChartView:self.chartView];
    }
    CGSize size = CGSizeMake(108*sectionCount, 26);
    return size;
}

- (CGRect)legendFrameWithPosition:(MYLegendPosition)position
{
    CGRect frame = self.superview.frame;
    
    if (position == MYLegendTop) {
        CGSize size = [self totalSize];
        CGFloat maxWidth = self.superview.frame.size.width - kLegendPadding*2;
        if (maxWidth > size.width) {
            
            self.frame = CGRectMake((maxWidth - size.width)/2.0f, 5, size.width, size.height);
        }
        else
        {
            self.frame = CGRectMake(kLegendPadding, 5, maxWidth, (size.height + 5)*ceil(size.width/maxWidth));
        }
    }
    else if (position == MYLegendRight)
    {
        
    }
    else if (position == MYLegendBottom)
    {
        CGSize size = [self totalSize];
        CGFloat maxWidth = self.superview.frame.size.width - kLegendPadding*2;
        if (maxWidth > size.width) {
            self.frame = CGRectMake((maxWidth - size.width)/2.0f, frame.size.height - size.height - 5, size.width, size.height);
        }
        else
        {
            int lineCount = ceil(size.width/maxWidth);
            CGFloat height = (size.height + 5)*lineCount;
            self.frame = CGRectMake(kLegendPadding, frame.size.height - height, maxWidth, height);
        }
    }
    else if (position == MYLegendLeft)
    {
        
    }
    return self.frame;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    int sectionCount = [self.chartView.dataSource numberOfSectionsInChartView:self.chartView];
    if ([self.chartView.dataSource respondsToSelector:@selector(numberOfLineSectionsInChartView:)]) {
        sectionCount += [self.chartView.dataSource numberOfLineSectionsInChartView:self.chartView];
    }
    
    int lineCount = floor(self.frame.size.width/100);
    
    for (int i = 0; i < sectionCount; i++) {
        
        UIColor *color = [UIColor blackColor];
        if (self.legendStateArray && i < self.legendStateArray.count && [[self.legendStateArray objectAtIndex:i] boolValue]) {
            color = [UIColor lightGrayColor];
            CGContextSetFillColorWithColor(context, [[self.chartView.dataSource chartView:self.chartView colorInSection:i] colorWithAlphaComponent:0.3].CGColor);
        }
        else
        {
            CGContextSetFillColorWithColor(context, [self.chartView.dataSource chartView:self.chartView colorInSection:i].CGColor);
        }
        
        CGContextFillRect(context, CGRectMake((i%lineCount)*103 + 5, 6+(i/lineCount)*20, 18, 18));
        NSString *title = [self.chartView.dataSource chartView:self.chartView legendTitleImSection:i];
        [title drawInRect:CGRectMake((i%lineCount)*103 + 25, 7+(i/lineCount)*20, 80, 16) withAttributes:@{NSFontAttributeName:self.legendFont,NSForegroundColorAttributeName:color}];
    }
}

@end
