//
//  TabStop.h
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 2/12/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCTabStop : NSObject

@property (nonatomic, assign) NSUInteger start;
@property (nonatomic, assign) NSUInteger end;
@property (nonatomic, readonly) NSUInteger length;

- (id)initWithStart:(NSUInteger)startIx andEnd:(NSUInteger)endIx;
- (NSRange)range;
- (NSRange)rangeWithOffset:(int)offset;

- (BOOL)isZeroWidth;

@end
