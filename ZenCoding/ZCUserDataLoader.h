//
//  ZCUserDataLoader.h
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 8/1/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCUserDataLoader : NSObject

+ (NSDictionary *)userData;
+ (NSDictionary *)variables;
+ (NSArray *)snippets;
+ (NSDictionary *)profiles;

@end
