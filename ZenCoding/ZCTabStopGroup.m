//
//  ZCTabStopGroup.m
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 2/13/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import "ZCTabStopGroup.h"

@implementation ZCTabStopGroup

- (id)init {
    if (self = [super init]) {
        _list = [NSMutableArray new];
    }
    
    return self;
}

- (void)add:(ZCTabStop *)tabStop {
	[_list addObject:tabStop];
}

- (void)addForStart:(NSUInteger)start andEnd:(NSUInteger)end {
	ZCTabStop *ts = [[ZCTabStop alloc] initWithStart:start andEnd:end];
	[self add:ts];
	[ts release];
}

- (NSArray *)list {
	return _list;
}

- (NSUInteger)length {
	return [_list count];
}

- (ZCTabStop *)tabStopAtIndex:(NSUInteger)ix {
	return [_list objectAtIndex:ix];
}

- (void)dealloc {
	[_list release];
	[super dealloc];
}

@end
