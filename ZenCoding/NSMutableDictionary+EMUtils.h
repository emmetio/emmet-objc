//
//  NSMutableDictionary+ZCUtils.h
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 3/21/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (EMUtils)
- (id)objectOfClass:(Class)cl forKey:(NSString *)key;
- (NSMutableDictionary *) dictionaryForKey:(NSString *)key;
- (NSMutableArray *) arrayForKey:(NSString *)key;

@end
