//
//  NSDictionary+Merge.h
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 3/20/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Merge)
+ (NSDictionary *) dictionaryByMerging: (NSDictionary *) dict1 with: (NSDictionary *) dict2;
- (NSDictionary *) dictionaryByMergingWith: (NSDictionary *) dict;
@end
