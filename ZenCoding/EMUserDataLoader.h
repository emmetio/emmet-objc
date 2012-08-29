//
//  Created by Sergey Chikuyonok on 8/1/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMUserDataLoader : NSObject

+ (NSDictionary *)userData;
+ (NSDictionary *)variables;
+ (NSArray *)snippets;
+ (NSDictionary *)syntaxProfiles;
+ (NSDictionary *)createOutputProfileFromDict:(NSDictionary *)dict;
+ (void)resetDefaults;

@end
