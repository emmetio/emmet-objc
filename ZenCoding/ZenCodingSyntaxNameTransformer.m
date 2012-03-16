//
//  ZenCodingSyntaxNameTransformer.m
//  ZenCoding
//
//  Created by Sergey on 3/16/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "ZenCodingSyntaxNameTransformer.h"

@implementation ZenCodingSyntaxNameTransformer

+ (Class)transformedValueClass {
	return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
	return YES;
}

- (id)transformedValue:(id)value {
	if (value != nil) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSArray *syntaxes = [defaults arrayForKey:@"syntax"];
		for (NSDictionary *syntax in syntaxes) {
			if ([[syntax valueForKey:@"id"] isEqual:value])
				return [syntax valueForKey:@"title"];
		}
	}
	
	return nil;
}

- (id)reverseTransformedValue:(id)value {
	if (value != nil) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSArray *syntaxes = [defaults arrayForKey:@"syntax"];
		for (NSDictionary *syntax in syntaxes) {
			if ([[syntax valueForKey:@"title"] isEqual:value])
				return [syntax valueForKey:@"id"];
		}
	}
	
	return nil;
}

@end
