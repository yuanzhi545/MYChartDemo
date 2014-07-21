//
//  MYBgLayer.m
//  MYChartDemo
//
//  Created by yuan zhi on 7/9/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import "MYColumnBgLayer.h"

@implementation MYColumnBgLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.borderColor = [UIColor colorWithWhite:0.2f alpha:1.0f].CGColor;
        self.borderWidth = 0.5f;
        self.masksToBounds = YES;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGFloat stepHeight = self.frame.size.height/6.0f;
    
    
    CGContextClearRect(ctx, self.bounds);
    for (int i = 0; i < 6; i++) {
        if (i%2 == 0) {
            CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0.9 alpha:1.0f].CGColor);
        }
        else
        {
            CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0.95 alpha:1.0f].CGColor);
        }
        CGContextAddRect(ctx, CGRectMake(0, i*stepHeight, self.frame.size.width, stepHeight));
        CGContextFillPath(ctx);
    }
    
    
}
@end
