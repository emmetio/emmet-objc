//
//  TabStop.m
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 2/12/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import "ZCTabStop.h"

@implementation ZCTabStop

@synthesize start, end, length;

- (id)initWithStart:(NSUInteger)startIx andEnd:(NSUInteger)endIx {
    if (self = [super init]) {
        self.start = startIx;
		self.end = endIx;
    }
    
    return self;
}

- (NSUInteger)length {
	return self.end - self.start;
}

- (BOOL)isZeroWidth {
	return self.start == self.end;
}

- (NSRange)range {
	return [self rangeWithOffset:0];
}


- (NSRange)rangeWithOffset:(int)offset {
	return NSMakeRange(offset + self.start, self.length);
}

@end
