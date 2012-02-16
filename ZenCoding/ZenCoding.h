//
//  ZenCoding.h
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 2/9/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSCocoa.h"

@interface ZenCoding : NSObject

@property (nonatomic, retain) id context;
@property (nonatomic, readonly, retain) JSCocoa *jsc;

+ (ZenCoding *)sharedInstance;
- (BOOL)runAction:name;
- (JSValueRef)evalFunction:(NSString *)funcName withArguments:arguments, ... NS_REQUIRES_NIL_TERMINATION;
@end
