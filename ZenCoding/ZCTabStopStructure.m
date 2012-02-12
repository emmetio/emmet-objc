//
//  ZCTabStopStructure.m
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 2/13/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import "ZCTabStopStructure.h"

@implementation ZCTabStopStructure

- (id)initWithText:(NSString *)text {
	if (self = [super init]) {
		_text = [text retain];
		_groups = [NSMutableDictionary new];
	}
	
	return self;
}

- (NSString *)text {
	return _text;
}

- (void)addTabStopToGroup:(NSString *)groupName start:(NSUInteger)start end:(NSUInteger)end {
	if (![_groups objectForKey:groupName]) {
		ZCTabStopGroup *g = [ZCTabStopGroup new];
		[_groups setValue:g forKey:groupName];
		[g release];
	}
	
	[[self namedGroup:groupName] addForStart:start andEnd:end];
}
- (NSDictionary *)groups {
	return _groups;
}

- (NSUInteger)tabStopsCount {
	NSUInteger count = 0;
	for (ZCTabStopGroup *group in _groups) {
		count += [group length];
	}
	
	return count;
}

- (NSArray *)sortedGroupKeys {
	return [[_groups allKeys] sortedArrayUsingComparator:^(id obj1, id obj2) {
		return [(NSString *)obj1 compare:(NSString *)obj2];
	}];
}

- (ZCTabStop *)firstTabStop {
	NSArray *keys = [self sortedGroupKeys];
	if (keys && [keys count]) {
		return [self tabStop:[keys objectAtIndex:0] atIndex:0];
	}
	
	return nil;
}

- (ZCTabStopGroup *)namedGroup:(NSString *)name {
	return [_groups objectForKey:name];
}

- (ZCTabStop *)tabStop:(NSString *)name atIndex:(NSUInteger)ix {
	return [[self namedGroup:name] tabStopAtIndex:ix];
}

- (void)dealloc {
	[_text release];
	[_groups release];
}

@end
