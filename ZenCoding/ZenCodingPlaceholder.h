//
//  ZenCodingPlaceholder.h
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 2/13/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZenCodingPlaceholder : NSObject

@property (nonatomic, readonly, assign) NSUInteger start;
@property (nonatomic, readonly, assign) NSUInteger end;
@property (nonatomic, readonly, assign) NSString *group;
@property (nonatomic, readonly, retain) NSString *placeholder;

- (id) initWithStart:(NSUInteger)startPos end:(NSUInteger)endPos group:(NSString *)groupName andValue:(NSString *)value;

@end
