//
//  MYPieValues.h
//  MYChartDemo
//
//  Created by yuan zhi on 3/26/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NSNumber* (^MYFetchBlock)(NSUInteger index);

@interface MYPieValues : NSObject
@property (nonatomic, strong) NSMutableArray *valueArray;
@property (nonatomic, strong) NSMutableArray *percentArray;
@property (nonatomic, strong) NSMutableArray *anglesArray;
@property (nonatomic, assign) NSUInteger sliceCount;

- (instancetype)initWithSliceCount:(NSUInteger)sliceCount block:(MYFetchBlock)block;
@end
