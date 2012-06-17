//
//  CodaZenEditor.m
//  ZenCodingCoda
//
//  Created by Сергей Чикуёнок on 2/19/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import "CodaZenEditor.h"
#import <ZenCoding/ZenCoding.h>
#import <ZenCoding/ZenCodingPromptDialogController.h>

@implementation CodaZenEditor

@synthesize tv;

- (id)initWithCodaView:(CodaTextView *)view {
	if (self = [super init]) {
		self.tv = view;
	}
	
	return self;
}

- (NSUInteger) caretPos {
	NSRange sel = [self selectionRange];
	return sel.location;
}

- (void)setCaretPos:(NSUInteger)caretPos {
	[self.tv setSelectedRange:NSMakeRange(caretPos, 0)];
}

- (NSRange) selectionRange {
    return [self.tv selectedRange];
}

- (void) setSelectionRange:(NSRange)range {
    [self.tv setSelectedRange:range];
}

- (NSString *)selection {
	return [[self content] substringWithRange:[self.tv selectedRange]];
}

- (NSString *)content {
    return [self.tv string];
}

- (NSString *)syntax {
	// detect syntax from file name
	if ([self filePath]) {
		NSString *ext = [[[self filePath] pathExtension] lowercaseString];
		ZenCoding *zc = [ZenCoding sharedInstance];
		if ([zc.jsc toBool:[zc evalFunction:@"zen_coding.require('resources').hasSyntax" withArguments:ext, nil]]) {
			return ext;
		}
	}
    return DEFAULT_SYNTAX;
}

- (NSString *)profileName {
    return DEFAULT_PROFILE;
}

- (NSRange)currentLineRange {
    NSString *content = [self content];
	return [content lineRangeForRange:NSMakeRange(self.caretPos, 0)];
}

- (NSString *)currentLine {
	return [[self content] substringWithRange:[self currentLineRange]];
}

- (void) replaceContentWithValue:(NSString *)value from:(NSUInteger)start to:(NSUInteger)end withoutIndentation:(BOOL)noIndent {
	// check if range is in bounds
	if (end <= [[self.tv string] length]) {
		
		[self.tv beginUndoGrouping];
		
		// extract tabstops and clean-up output
		ZenCoding *zc = [ZenCoding sharedInstance];
		JSValueRef output = [zc evalFunction:@"zen_coding.require('tabStops').extract" withArguments:value, nil];
		
		NSDictionary *tabstopData = [zc.jsc toObject:output];
		value = [tabstopData valueForKey:@"text"];
		[self.tv replaceCharactersInRange:NSMakeRange(start, end - start) withString:value];
		
		// locate first tabstop and place cursor in it
		NSArray *tabstops = [tabstopData objectForKey:@"tabstops"];
		if (tabstops != nil && [tabstops count]) {
			NSDictionary *firstTabstop = [tabstops objectAtIndex:0];
			if (firstTabstop) {
				NSNumber *tsStart = (NSNumber *)[firstTabstop objectForKey:@"start"];
				NSNumber *tsEnd = (NSNumber *)[firstTabstop objectForKey:@"end"];
				NSRange selRange = NSMakeRange([tsStart unsignedIntegerValue] + start, [tsEnd unsignedIntegerValue] - [tsStart unsignedIntegerValue]);
				
				[self setSelectionRange:selRange];
				return;
			}
		}
		
		// unable to locate tabstops, place caret at the end of content
		[self setCaretPos:start + [value length]];
		
		[self.tv endUndoGrouping];
	}
}

- (NSString *)prompt:(NSString *)label {	
	return [ZenCodingPromptDialogController promptForWindow:[self.tv window] withLabel:label];
}

- (NSString *)filePath {
	return [self.tv path];
}

@end
