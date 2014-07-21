//
//  MYColumnView.m
//  MYChartDemo
//
//  Created by yuan zhi on 3/27/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import "MYColumnBarView.h"
#import "MYBarChartView.h"

@interface MYColumnBarView ()
@property (nonatomic, strong) NSMutableArray *leftAsixArray;
@property (nonatomic, strong) NSMutableArray *rightAsixArray;
@property (nonatomic, strong) NSMutableArray *barArray;
@property (nonatomic, strong) NSMutableArray *lineArray;
@property (nonatomic, strong) NSMutableArray *bottomLabelArray;

@property (nonatomic, strong) NSMutableArray *barTitleArray;
@property (nonatomic, strong) NSMutableArray *lineTitleArray;
@end

@implementation MYColumnBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    
    return self;
}

- (void)initView
{
    self.axisFont = [UIFont fontWithName:@"Helvetica" size:14];
    self.leftAsixArray = [NSMutableArray array];
    self.rightAsixArray = [NSMutableArray array];
    self.barArray = [NSMutableArray array];
    self.lineArray = [NSMutableArray array];
    self.bottomLabelArray = [NSMutableArray array];
    self.barTitleArray = [NSMutableArray array];
    self.lineTitleArray = [NSMutableArray array];
    
    bgLayer = [[MYColumnBgLayer alloc] init];
    [self.layer addSublayer:bgLayer];
    
    mScrollView = [[UIScrollView alloc] init];
    mScrollView.backgroundColor = [UIColor clearColor];
    mScrollView.clipsToBounds = YES;
    [self addSubview:mScrollView];
    
    tipView = [[UIView alloc] init];
    tipView.backgroundColor = [UIColor colorWithWhite:0.7f alpha:0.7f];
    tipView.hidden = YES;
    [mScrollView addSubview:tipView];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [mScrollView addGestureRecognizer:longPressGesture];

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tapGesture];
    
    self.legendPosition = MYLegendBottom;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, kTitleHeight);
    
    CGRect legendFrame = [self.legendView legendFrameWithPosition:self.legendPosition];
    switch (self.legendPosition) {
        case MYLegendTop:
            
            break;
        case MYLegendRight:
            
            break;
        case MYLegendBottom:
            self.legendView.frame = legendFrame;
            break;
        case MYLegendLeft:
            
            break;
        default:
            break;
    }
}

#pragma mark - MYLegendViewDelegate
- (void)legendView:(MYLegendView *)legendView didSelectSection:(NSInteger)section
{
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationDuration:0.3f];
    if (self.barArray.count > section) {
        NSMutableArray *array = [self.barArray objectAtIndex:section];
        [array enumerateObjectsUsingBlock:^(MYBarChartView *view, NSUInteger idx, BOOL *stop) {
            view.barLayer.hidden = YES;
        }];
        
        
        array = [self.barTitleArray objectAtIndex:section];
        [array enumerateObjectsUsingBlock:^(CATextLayer *layer, NSUInteger idx, BOOL *stop) {
            layer.hidden = YES;
        }];
    }
    else
    {
       CAShapeLayer *layer = [self.lineArray objectAtIndex:section - self.barArray.count];
        layer.hidden = YES;
        
        NSMutableArray *array = [self.lineTitleArray objectAtIndex:section - self.barArray.count];
        [array enumerateObjectsUsingBlock:^(CATextLayer *layer, NSUInteger idx, BOOL *stop) {
            layer.hidden = YES;
        }];
    }
}

- (void)legendView:(MYLegendView *)legendView cancelSelectSection:(NSInteger)section
{
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationDuration:0.3f];
    if (self.barArray.count > section) {
        NSMutableArray *array = [self.barArray objectAtIndex:section];
        
        [array enumerateObjectsUsingBlock:^(MYBarChartView *view, NSUInteger idx, BOOL *stop) {
            view.barLayer.hidden = NO;
        }];
        
        array = [self.barTitleArray objectAtIndex:section];
        [array enumerateObjectsUsingBlock:^(CATextLayer *layer, NSUInteger idx, BOOL *stop) {
            layer.hidden = NO;
        }];
    }
    else
    {
        CAShapeLayer *layer = [self.lineArray objectAtIndex:section - self.barArray.count];
        layer.hidden = NO;
        
        NSMutableArray *array = [self.lineTitleArray objectAtIndex:section - self.barArray.count];
        [array enumerateObjectsUsingBlock:^(CATextLayer *layer, NSUInteger idx, BOOL *stop) {
            layer.hidden = NO;
        }];
    }
}

#pragma mark - 手势

- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    [self checkTipView:gesture];
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self checkTipView:gesture];
    }
}


- (void)checkTipView:(UIGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:mScrollView];
    NSInteger sectionCount = [self.dataSource numberOfSectionsInChartView:self];
    NSInteger rowCount = [self.dataSource chartView:self numberOfRowsInSection:0];
    int row = floor(location.x/(barPadding+barWidth*sectionCount));
    if (row < 0 || row >= rowCount) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [self selectChart:nil];
            [UIView animateWithDuration:0.2f animations:^{
                tipView.hidden = YES;
            }];
        }
        return;
    }
    
    if (location.x < row*barPadding + sectionCount*barWidth*row + barPadding) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [self selectChart:nil];
            [UIView animateWithDuration:0.2f animations:^{
                tipView.hidden = YES;
            }];
        }
        
        return;
    }
    
    int section = floor((location.x - (1+row)*barPadding - row*barWidth*sectionCount)/barWidth);
    if ([[self.legendView.legendStateArray objectAtIndex:section] boolValue]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [self selectChart:nil];
            [UIView animateWithDuration:0.2f animations:^{
                tipView.hidden = YES;
            }];
        }
        return;
    }
    
    CGRect frame = tipView.frame;
    
    CGFloat x = (row+1)*barPadding + row*barWidth*sectionCount + section*barWidth;
    if (frame.origin.x != x || tipView.hidden) {
        [self selectChart:[NSIndexPath indexPathForRow:row inSection:section]];
        if (tipView.hidden) {
            tipView.hidden = NO;
            frame.origin.x = x;
            tipView.frame = frame;
            [mScrollView bringSubviewToFront:tipView];
        }
        else
        {
            frame.origin.x = x;
            [UIView animateWithDuration:0.2 animations:^{
                tipView.frame = frame;
                [mScrollView bringSubviewToFront:tipView];
            }];
            
        }
        
    }
}

- (void)selectChart:(NSIndexPath *)indexPath
{
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = 0.3;
    [self.titleLabel.layer addAnimation:animation forKey:nil];
    
    if (indexPath == nil) {
        self.titleLabel.text = @"";
    }
    else
    {
        NSString *title = [self.dataSource chartView:self displayValueForRowAtIndexPath:indexPath];
        self.titleLabel.text = title;
    }

}


#pragma mark - 布局信息
- (void)calculateYAxisWidth:(NSNumber **)maxNumber minNumber:(NSNumber **)minNumber isLeft:(BOOL)isLeft
{
    NSInteger startIndex = isLeft?0:[self.dataSource numberOfSectionsInChartView:self];
    NSInteger endIndex = isLeft?[self.dataSource numberOfSectionsInChartView:self]:startIndex+[self.dataSource numberOfLineSectionsInChartView:self];
    for (NSInteger i = startIndex; i < endIndex; i++) {
        for (int j = 0; j < [self.dataSource chartView:self numberOfRowsInSection:i]; j++) {
            NSNumber *number = [self.dataSource chartView:self valueForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            if ([number compare:*maxNumber] == NSOrderedDescending) {
                *maxNumber = number;
            }
            else if ([number compare:*minNumber] == NSOrderedAscending) {
                *minNumber = number;
            }
        }
    }
    
    NSNumberFormatter *_labelFormatter = [[NSNumberFormatter alloc] init];
    [_labelFormatter setNumberStyle:isLeft?NSNumberFormatterDecimalStyle:NSNumberFormatterPercentStyle];
    
    NSString *str = [_labelFormatter stringFromNumber:*maxNumber];
    CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:self.axisFont}];
    
    if ([*minNumber doubleValue] < 0) {
        str = [_labelFormatter stringFromNumber:*minNumber];
        CGSize minSize = [str sizeWithAttributes:@{NSFontAttributeName:self.axisFont}];
        if (isLeft) {
            leftAxisWidth = MAX(size.width, minSize.width)+ 15;
        }
        else
        {
            rightAxisWidth = MAX(size.width, minSize.width)+ 15;
        }
    }
    else
    {
        if (isLeft) {
            leftAxisWidth = size.width+ 15;
        }
        else
        {
            rightAxisWidth = size.width+ 15;
        }
    }
}

- (void)calculateYAxisStep:(double)maxValue minValue:(double)minValue isLeft:(BOOL)isLeft
{
    NSNumberFormatter *_labelFormatter = [[NSNumberFormatter alloc] init];
    [_labelFormatter setNumberStyle:isLeft?NSNumberFormatterDecimalStyle:NSNumberFormatterPercentStyle];
    
    NSNumber *yAxisValue;
    
    NSMutableArray *array = isLeft?self.leftAsixArray:self.rightAsixArray;
    if (minValue < 0) {
        int pow = 0;
        maxValue = maxValue - minValue;
        while (maxValue >= 100) {
            maxValue /= 10;
            pow++;
        }
        
        int step = ceil(maxValue/4.5f);
        
        double value = 0;
        int i = 0;
        while (value > minValue) {

            CATextLayer *textLayer = [self createLabelLayer:14.0f];
            [textLayer setAlignmentMode:isLeft?kCAAlignmentRight:kCAAlignmentLeft];
            if (isLeft) {
                yAxisValue = [NSNumber numberWithInt:-i*step*powf(10, pow)];
            }
            else
            {
                yAxisValue = [NSNumber numberWithDouble:-i*step*powf(10, pow)/100.0f];
            }
            [textLayer setString:[_labelFormatter stringFromNumber:yAxisValue]];

            [array insertObject:textLayer atIndex:0];
            value = [[NSNumber numberWithDouble:-i*step*powf(10, pow)] doubleValue];
            i++;
        }
        if (isLeft) {
            leftYAxisZeroHeight = (7-i)*stepHeight;
            leftStep = step*powf(10, pow);
        }
        else
        {
            rightYAxisZeroHeight = (7-i)*stepHeight;
            rightStep = step*powf(10, pow);
        }
        for (int j = i; j<= 6; j++) {
            CATextLayer *textLayer = [self createLabelLayer:14.0f];
            [textLayer setAlignmentMode:isLeft?kCAAlignmentRight:kCAAlignmentLeft];
            if (isLeft) {
                yAxisValue = [NSNumber numberWithInt:(j-i+1)*step*powf(10, pow)];
            }
            else
            {
                yAxisValue = [NSNumber numberWithDouble:(j-i+1)*step*powf(10, pow)/100.0f];
            }
            [textLayer setString:[_labelFormatter stringFromNumber:yAxisValue]];
            [array addObject:textLayer];
        }
    }
    else
    {
        int pow = 0;
        while (maxValue >= 100) {
            maxValue /= 10;
            pow++;
        }
        
        int step = ceil(maxValue/4.5f);
        
        if (isLeft) {
            leftYAxisZeroHeight = self.frame.size.height - self.legendView.frame.size.height - kBottomHeight - kTitleHeight;
            leftStep = step*powf(10, pow);
        }
        else
        {
            rightYAxisZeroHeight = self.frame.size.height - self.legendView.frame.size.height - kBottomHeight - kTitleHeight;
            rightStep = step*powf(10, pow);
        }
        
        for (int i = 0; i <= 6; i++) {
            CATextLayer *textLayer = [self createLabelLayer:14.0f];
            [textLayer setAlignmentMode:isLeft?kCAAlignmentRight:kCAAlignmentLeft];
            if (isLeft) {
                yAxisValue = [NSNumber numberWithInt:i*step*powf(10, pow)];
            }
            else
            {
                yAxisValue = [NSNumber numberWithDouble:i*step*powf(10, pow)/100.0f];
            }
            [textLayer setString:[_labelFormatter stringFromNumber:yAxisValue]];
            [array addObject:textLayer];
        }
    }
}

- (void)calculateLeftYAxis
{

    NSNumber *maxNumber = @(0);
    NSNumber *minNumber = @(0);
    [self calculateYAxisWidth:&maxNumber minNumber:&minNumber isLeft:YES];
    
    [self calculateYAxisStep:[maxNumber doubleValue] minValue:[minNumber doubleValue] isLeft:YES];

}

- (void)calculateRightYAxis
{
    NSNumber *maxNumber = @(0);
    NSNumber *minNumber = @(0);
    [self calculateYAxisWidth:&maxNumber minNumber:&minNumber isLeft:NO];
    
    [self calculateYAxisStep:[maxNumber doubleValue]*100 minValue:[minNumber doubleValue]*100 isLeft:NO];
}

- (void)calculateXAxis
{
    [CATransaction setDisableActions:YES];
    mScrollView.frame = canvasFrame;
    bgLayer.frame = CGRectMake(canvasFrame.origin.x, canvasFrame.origin.y, canvasFrame.size.width, canvasFrame.size.height - kBottomHeight);
    [bgLayer setNeedsDisplay];
    [CATransaction setDisableActions:NO];
    
    NSInteger barSectionCount = [self.dataSource numberOfSectionsInChartView:self];
    NSInteger barRowCount = [self.dataSource chartView:self numberOfRowsInSection:0];
    
    CGFloat minWidth = (barSectionCount*kBarMinWidth + kBarPadding)*barRowCount + kBarPadding;
    if (minWidth > canvasFrame.size.width) {
        mScrollView.contentSize = CGSizeMake(minWidth, canvasFrame.size.height);
        barWidth = kBarMinWidth;
        barPadding = kBarPadding;
    }
    else
    {
        mScrollView.contentSize = canvasFrame.size;
        CGFloat maxWidth = (barSectionCount*kBarMaxWidth + kBarPadding)*barRowCount + kBarPadding;
        if (maxWidth < canvasFrame.size.width) {
            barWidth = kBarMaxWidth;
            barPadding = (canvasFrame.size.width - barRowCount*barSectionCount*kBarMaxWidth)/(barRowCount + 1);
        }
        else
        {
            barPadding = kBarPadding;
            barWidth = (canvasFrame.size.width - kBarPadding*(barRowCount + 1))/barRowCount/barSectionCount;
        }
    }
     tipView.frame = CGRectMake(0, 0, barWidth, canvasFrame.size.height - kBottomHeight);
    
}

- (void)calculateLayout
{
    [self.leftAsixArray removeAllObjects];
    [self.rightAsixArray removeAllObjects];
    leftAxisWidth = 0;
    rightAxisWidth = 0;
    
    stepHeight = (self.frame.size.height - self.legendView.frame.size.height - kTitleHeight - kBottomHeight)/6.0f;
    
    [self calculateLeftYAxis];
    if ([self.dataSource respondsToSelector:@selector(numberOfLineSectionsInChartView:)]) {
        [self calculateRightYAxis];
    }
    
    switch (self.legendPosition) {
        case MYLegendTop:
            
            break;
        case MYLegendRight:
            
            break;
        case MYLegendBottom:
            canvasFrame = CGRectMake(leftAxisWidth,
                                     kTitleHeight,
                                     self.frame.size.width - leftAxisWidth - rightAxisWidth,
                                     self.frame.size.height - self.legendView.frame.size.height - kTitleHeight);
            break;
        case MYLegendLeft:
            
            break;
        default:
            break;
    }
   
    
    [self calculateXAxis];
    
}


- (CATextLayer *)createLabelLayer:(CGFloat)fontSize
{
    CATextLayer *textLayer = [CATextLayer layer];
    [textLayer setContentsScale:[[UIScreen mainScreen] scale]];
    CGFontRef font = CGFontCreateWithFontName((__bridge CFStringRef) [self.axisFont fontName]);
    [textLayer setFont:font];
    [textLayer setForegroundColor:[UIColor colorWithWhite:0.2 alpha:1].CGColor];
    CFRelease(font);
    [textLayer setFontSize:fontSize];
    return textLayer;
}

- (CAShapeLayer *)createLineLayer
{
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    [lineLayer setContentsScale:[[UIScreen mainScreen] scale]];
    lineLayer = [CAShapeLayer layer];
    lineLayer.lineCap = kCALineCapRound;
    lineLayer.lineJoin = kCALineJoinRound;
    lineLayer.fillColor = [[UIColor clearColor] CGColor];
    lineLayer.lineWidth = 1.0;
    return lineLayer;
}

- (void)reloadData
{
    [self.leftAsixArray makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.rightAsixArray makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    [self.barArray enumerateObjectsUsingBlock:^(NSMutableArray *array, NSUInteger idx, BOOL *stop) {
        [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
    [self.barTitleArray enumerateObjectsUsingBlock:^(NSMutableArray *array, NSUInteger idx, BOOL *stop) {
        [array makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    }];
    [self.lineTitleArray enumerateObjectsUsingBlock:^(NSMutableArray *array, NSUInteger idx, BOOL *stop) {
        [array makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    }];
    
    [self.lineArray makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.bottomLabelArray makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    [self.barArray removeAllObjects];
    [self.lineArray removeAllObjects];
    [self.bottomLabelArray removeAllObjects];
    
    if (self.dataSource) {
        [self calculateLayout];
        
        [self.leftAsixArray enumerateObjectsUsingBlock:^(CATextLayer *textLayer, NSUInteger idx, BOOL *stop) {
            [self.layer addSublayer:textLayer];
            textLayer.frame = CGRectMake(0, (6-idx)*stepHeight +kTitleHeight - 10, leftAxisWidth-2, 20);
        }];
        
        [self.rightAsixArray enumerateObjectsUsingBlock:^(CATextLayer *textLayer, NSUInteger idx, BOOL *stop) {
            [self.layer addSublayer:textLayer];
            textLayer.frame = CGRectMake(self.frame.size.width - rightAxisWidth + 2, (6-idx)*stepHeight + kTitleHeight - 10, rightAxisWidth - 2, 20);
        }];
        
        NSInteger barSectionCount = [self.dataSource numberOfSectionsInChartView:self];
        
        NSNumberFormatter *_labelFormatter = [[NSNumberFormatter alloc] init];
        [_labelFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        for (int i = 0; i < barSectionCount; i++) {
            NSInteger barCount = [self.dataSource chartView:self numberOfRowsInSection:i];
            NSMutableArray *array = [NSMutableArray array];
            NSMutableArray *titleArray = [NSMutableArray array];
            for (int j = 0; j < barCount; j++) {
                MYBarChartView *barView = [[MYBarChartView alloc] init];
                barView.clipsToBounds = YES;
                barView.barLayer.strokeColor = [self.dataSource chartView:self colorInSection:i].CGColor;
                [mScrollView addSubview:barView];
                
                NSNumber *value = [self.dataSource chartView:self valueForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                double dv = [value doubleValue];
                dv = dv/leftStep;
                dv = dv*stepHeight;
                 CGFloat height = leftYAxisZeroHeight - dv;
                
                barView.isPositive = dv > 0;
        
                barView.frame = CGRectMake(barPadding*(j+1)+(barSectionCount*j+i)*barWidth, MIN(height, leftYAxisZeroHeight), barWidth, ABS(height - leftYAxisZeroHeight));
                [array addObject:barView];
                
                
                CATextLayer *textLayer = [self createLabelLayer:14.0f];
                [textLayer setAlignmentMode:kCAAlignmentCenter];
                NSNumber *number = [self.dataSource chartView:self valueForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                CGRect frame = barView.frame;
                if (barView.isPositive) {
                    frame.origin.y -= 20;
                    frame.size.height = 20;
                }
                else
                {
                    frame.origin.y += frame.size.height;
                    frame.size.height = 20;
                }

                [textLayer setString:[_labelFormatter stringFromNumber:number]];
                textLayer.frame = frame;
                [mScrollView.layer addSublayer:textLayer];
                [titleArray addObject:textLayer];
            }
            [self.barArray addObject:array];
            [self.barTitleArray addObject:titleArray];
        }
        
        [_labelFormatter setNumberStyle:NSNumberFormatterPercentStyle];
        for (NSInteger i = barSectionCount; i < barSectionCount + [self.dataSource numberOfLineSectionsInChartView:self]; i++) {
            NSInteger barCount = [self.dataSource chartView:self numberOfRowsInSection:i];
            CAShapeLayer *layer = [self createLineLayer];
            [mScrollView.layer addSublayer:layer];
            layer.strokeColor = [self.dataSource chartView:self colorInSection:i].CGColor;
            
            CGMutablePathRef progressline = CGPathCreateMutable();

            NSMutableArray *titleArray = [NSMutableArray array];
            for (int j = 0; j < barCount; j++) {
                CATextLayer *textLayer = [self createLabelLayer:14.0f];
                [textLayer setAlignmentMode:kCAAlignmentCenter];
                
                NSNumber *value = [self.dataSource chartView:self valueForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                double dv = [value doubleValue];
                dv = dv/rightStep*100;
                dv = dv*stepHeight;
                CGFloat height = rightYAxisZeroHeight - dv;
                
                
                int padding = j%2 == 0 ? 1.5 : -1.5;
                
                if (j==0) {
                    CGPathAddEllipseInRect(progressline, NULL, CGRectMake(barPadding*(j+1)+barSectionCount*barWidth*(j+0.5)-2.5, height-2.5, 5, 5));
                    CGPathMoveToPoint(progressline, NULL,barPadding*(j+1)+barSectionCount*barWidth*(j+0.5)+1.5, height+padding);

                }
                else
                {
                    CGPathAddLineToPoint(progressline, NULL, barPadding*(j+1)+barSectionCount*barWidth*(j+0.5)-1.5, height+padding);
                    CGPathAddEllipseInRect(progressline, NULL, CGRectMake(barPadding*(j+1)+barSectionCount*barWidth*(j+0.5)-2.5, height-2.5, 5,5));
                    CGPathMoveToPoint(progressline, NULL,barPadding*(j+1)+barSectionCount*barWidth*(j+0.5)+1.5, height+padding);
                    
                }
                
                
                NSNumber *number = [self.dataSource chartView:self valueForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                CGRect frame = CGRectMake(barPadding*(j+1)+barSectionCount*barWidth*(j+0.5)-20, height, 40, 20);
                if (number.doubleValue > 0) {
                    frame.origin.y -= 20;
                    
                }
                
                [textLayer setString:[_labelFormatter stringFromNumber:number]];
                textLayer.frame = frame;
                [mScrollView.layer addSublayer:textLayer];
                [titleArray addObject:textLayer];
            }
            
            layer.path = progressline;
            
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = 0.5f;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
            pathAnimation.autoreverses = NO;
            [layer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            
            layer.strokeEnd = 1.0;
            
            [self.lineArray addObject:layer];
            [self.lineTitleArray addObject:titleArray];

        }
        
        for (int i = 0; i < [self.dataSource chartView:self numberOfRowsInSection:0]; i++) {
            NSString *title = [self.dataSource chartView:self titleForFooterInRow:i];
            
            CATextLayer *textLayer = [self createLabelLayer:12.0f];

            [textLayer setAlignmentMode:kCAAlignmentCenter];
            [textLayer setString:title];
            textLayer.frame = CGRectMake(barPadding*(i+0.5)+barSectionCount*barWidth*i, canvasFrame.size.height-kBottomHeight, barSectionCount*barWidth+barPadding, kBottomHeight);
            [mScrollView.layer addSublayer:textLayer];
            [self.bottomLabelArray addObject:textLayer];
        }
        
    }
}


@end
