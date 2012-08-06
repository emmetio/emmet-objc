//
//  ZenCodingTildePathTransformer.m
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 3/10/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "ZenCodingTildePathTransformer.h"

@implementation ZenCodingTildePathTransformer

+ (Class)transformedValueClass {
	return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
	return YES;
}

- (id)transformedValue:(id)value {
	if (value != nil && [value respondsToSelector:@selector(stringByAbbreviatingWithTildeInPath)]) {
		return [value stringByAbbreviatingWithTildeInPath];
	}
	
	return nil;
}

- (id)reverseTransformedValue:(id)value {
	if (value != nil && [value respondsToSelector:@selector(stringByExpandingTildeInPath)]) {
		return [value stringByExpandingTildeInPath];
	}
	
	return nil;
}

@end
