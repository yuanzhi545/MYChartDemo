//
//  MYPieValues.m
//  MYChartDemo
//
//  Created by yuan zhi on 3/26/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import "MYPieValues.h"

@implementation MYPieValues

- (instancetype)initWithSliceCount:(NSUInteger)sliceCount block:(MYFetchBlock)fetchBlock
{
    self = [super init];
    if (self) {
        _sliceCount = sliceCount;
        _percentArray = [[NSMutableArray alloc] initWithCapacity:sliceCount];
        _valueArray = [[NSMutableArray alloc] initWithCapacity:sliceCount];
        _anglesArray = [[NSMutableArray alloc] initWithCapacity:sliceCount];
   
        double sum = 0.0;
        for (NSUInteger currentIndex = 0; currentIndex < sliceCount; currentIndex++) {
            [_valueArray addObject:fetchBlock(currentIndex)];
            sum += [[_valueArray objectAtIndex:currentIndex] doubleValue];
        }
        
        CGFloat twoPie = (CGFloat) M_PI * 2.0;
        for (int currentIndex = 0; currentIndex < sliceCount; currentIndex++) {
            double percentage = [[_valueArray objectAtIndex:currentIndex] doubleValue] / sum;
            [_percentArray addObject:[NSNumber numberWithDouble:percentage]];
            
            CGFloat angle = (CGFloat) (twoPie * percentage);
            [_anglesArray addObject:[NSNumber numberWithDouble:angle]];
        }

    }
    return self;
}

@end
