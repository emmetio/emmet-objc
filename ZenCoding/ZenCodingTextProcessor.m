//
//  ZenCodingTextProcessor.m
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 2/13/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import "ZenCodingTextProcessor.h"
#import "ZenCodingPlaceholder.h"

@interface ZenCodingTextProcessor ()
- (NSString *)process;
@end

@implementation ZenCodingTextProcessor

@synthesize originalText, placeholders, marks, processedText, tabStops;

- (id)initWithText:(NSString *)text {
	if (self = [super init]) {
		self->placeholders = [NSMutableDictionary new];
		self->originalText = [text retain];
		self->marks = [NSMutableArray new];
		self->tabStops = [ZCTabStopStructure new];
		self->processedText = [self process];
	}
	
	return self;
}

- (NSString *)process {
	NSString *text = [self.originalText stringByReplacingOccurrencesOfString:CARET_PLACEHOLDER withString:@"${0:cursor}"];
	text = [[ZenCoding sharedInstance] processBeforePaste:text withDelegate:self];
	
	// replace all placeholders with actual values
	NSMutableString *buf = [NSMutableString new];
	int lastIx = 0;
	
	for (ZenCodingPlaceholder *placeholder in self.marks) {
		[buf appendString:[text substringWithRange:NSMakeRange(lastIx, placeholder.start - lastIx)]];
		
		NSString *ph = @"";
		if (![placeholder.group isEqualToString:CARET_GROUP] && [self.placeholders objectForKey:placeholder.group] != nil) {
			ph = [placeholders valueForKey:placeholder.group];
		}
		
		[self.tabStops addTabStopToGroup:placeholder.group 
							  start:[buf length] 
								end:[buf length] + [ph length]];
		[buf appendString:ph];
		lastIx = (int)placeholder.end;
	}
	
	[buf appendString:[text substringFromIndex:lastIx]];
	return buf;
}
																

- (NSString *)handleEscape:(NSString *)text {
	return text;
}

- (NSString *)handleTabstopAt:(int)ix withNumber:(NSString *)num andPlaceholder:(NSString *)placeholder {
	
	NSString *matchedToken;
	if (placeholder == nil) {
		matchedToken = [NSString stringWithFormat:@"${%@}", num];
	} else {
		matchedToken = [NSString stringWithFormat:@"${%@:%@}", num, placeholder];
	}

	NSString *ret = @"";
	ZenCodingPlaceholder *pl = nil;
	
	if (placeholder != nil && [placeholder isEqualToString:@"cursor"]) {
		pl = [[ZenCodingPlaceholder alloc] initWithStart:ix end:ix + [matchedToken length] group:CARET_GROUP andValue:@""];
	} else {
		if (placeholder != nil && [placeholder length])
			[self.placeholders setValue:placeholder forKey:num];
		
		if ([self.placeholders objectForKey:num] != nil)
			ret = [self.placeholders valueForKey:num];
		
		pl = [[ZenCodingPlaceholder alloc] initWithStart:ix end:ix + [matchedToken length] group:num andValue:ret];
	}
	
	if (pl != nil) {
		[((NSMutableArray*)self.marks) addObject:pl];
		[pl release];
	}
	
	return matchedToken;
}

- (void)dealloc {
	[super dealloc];
}

@end