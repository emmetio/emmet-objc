//
//  Created by Сергей Чикуёнок on 3/10/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "EMArrayTransformer.h"

@implementation EMArrayTransformer

- (id)initWithArray:(NSArray *)arr {
	if (self = [super init]) {
		values = [arr retain];
	}
	
	return self;
}

- (void)dealloc {
	[values release];
	[super dealloc];
}

+ (Class)transformedValueClass {
	return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation {
	return YES;
}

- (id)transformedValue:(id)value {
	if (value == nil) return nil;
	NSUInteger ix = [values indexOfObject:value];
	if (ix == NSNotFound) {
		return nil;
	}
	
	return [NSNumber numberWithUnsignedInteger:ix];
}

- (id)reverseTransformedValue:(id)value {
	if (value != nil && [value respondsToSelector:@selector(unsignedIntegerValue)]) {
		NSUInteger ix = [value unsignedIntegerValue];
		return [values objectAtIndex:ix];
	}
	
	return nil;
}

@end
