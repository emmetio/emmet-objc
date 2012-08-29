//
//  NSMutableDictionary+ZCUtils.m
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 3/21/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "NSMutableDictionary+EMUtils.h"

@implementation NSMutableDictionary (EMUtils)

- (id)objectOfClass:(Class)cl forKey:(NSString *)key {
	id val = [self objectForKey:key];
	if (!val || ![val isKindOfClass:cl]) {
		[self setObject:[[cl new] autorelease] forKey:key];
	}
	
	return [self objectForKey:key];
}

- (NSMutableDictionary *) dictionaryForKey:(NSString *)key {
	return (NSMutableDictionary *)[self objectOfClass:[NSMutableDictionary class] forKey:key];
}

- (NSMutableArray *) arrayForKey:(NSString *)key {
	return (NSMutableArray *)[self objectOfClass:[NSMutableArray class] forKey:key];
}

@end
