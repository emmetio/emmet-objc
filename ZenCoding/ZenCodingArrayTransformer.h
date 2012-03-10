//
//  ZenCodingArrayTransformer.h
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 3/10/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZenCodingArrayTransformer : NSValueTransformer {
	NSArray *values;
}

- (id)initWithArray:(NSArray *)arr;

@end
