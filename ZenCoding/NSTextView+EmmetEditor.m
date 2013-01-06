//
//  Created by Сергей Чикуёнок on 2/6/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import "NSTextView+EmmetEditor.h"
#import "EMPromptDialogController.h"

@implementation NSTextView (NSTextView_EmmetEditor)

- (NSUInteger) caretPos {
	NSRange sel = [self selectionRange];
	return sel.location;
}

- (void)setCaretPos:(NSUInteger)caretPos {
	[self setSelectedRange:NSMakeRange(caretPos, 0)];
}

- (NSRange) selectionRange {
    return [self selectedRange];
}

- (void) setSelectionRange:(NSRange)range {
    [self setSelectedRange:range];
}

- (NSString *)selection {
	return [[self content] substringWithRange:[self selectedRange]];
}

- (NSString *)content {
    return [self string];
}

- (NSString *)syntax {
    return DEFAULT_SYNTAX;
}

- (NSString *)profileName {
    return nil;
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
	if (end <= [[self string] length]) {
		// extract tabstops and clean-up output
		Emmet *em = [Emmet sharedInstance];
		
		id output = [em.jsc evalFunction:@"objcExtractTabstopsOnInsert" withArguments:value, nil];
		
		NSDictionary *tabstopData = [em.jsc convertJSObject:output toNativeType:@"object"];
		value = [tabstopData valueForKey:@"text"];

		NSRange updateRange = NSMakeRange(start, end - start);
		[self shouldChangeTextInRange:updateRange replacementString:value];
		[self replaceCharactersInRange:updateRange withString:value];
		[self didChangeText];
		
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
	}
}

- (NSString *)prompt:(NSString *)label {	
	return [EMPromptDialogController prompt:label];
}

- (NSString *)filePath {
	return @"not implemented yet";
}

@end
