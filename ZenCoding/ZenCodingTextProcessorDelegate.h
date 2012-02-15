//
//  ZenCodingTextProcessorDelegate.h
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 2/15/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZenCodingTextProcessorDelegate <NSObject>

- (NSString *)handleEscape:(NSString *)text;
- (NSString *)handleTabstopAt:(int)ix withNumber:(NSString *)num andPlaceholder:(NSString *)placeholder;

@end
