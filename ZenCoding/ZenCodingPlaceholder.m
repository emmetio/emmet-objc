//
//  ZenCodingPlaceholder.m
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 2/13/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import "ZenCodingPlaceholder.h"

@implementation ZenCodingPlaceholder

@synthesize start, end, group, placeholder;

- (id)initWithStart:(NSUInteger)startPos end:(NSUInteger)endPos group:(NSString *)groupName andValue:(NSString *)value {
	if (self = [super init]) {
		self->start = startPos;
		self->end = endPos;
		self->group = groupName;
		self->placeholder = [value retain];
	}
	
	return self;
}

- (void)dealloc {
	[self->placeholder release];
	[super dealloc];
}

@end
