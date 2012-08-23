//
//  TextMateZenEditor.m
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 8/11/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "TextMateEmmetEditor.h"
#import "ZenCoding.h"
#import "ZenCodingPromptDialogController.h"

TMLocation convertRangeToLocation(NSRange range, NSString *string) {
	unsigned numberOfLines, index, stringLength = [string length];
	TMLocation loc = (TMLocation){};
	NSRange lineRange;
	
	for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++) {
		lineRange = [string lineRangeForRange:NSMakeRange(index, 0)];
		if (NSLocationInRange(range.location, lineRange)) {
			loc.startLine = numberOfLines + 1;
			loc.startCol = range.location - lineRange.location + 1;
		}
		
		NSUInteger pos = range.location + range.length;
		if (pos - lineRange.location <= lineRange.length) {
			loc.endLine = numberOfLines + 1;
			loc.endCol = range.location + range.length - lineRange.location + 1;
		}
		
		index = NSMaxRange(lineRange);
	}
	
	return loc;
}

@interface TextMateEmmetEditor ()

- (NSArray *)linesOfText:(NSString *)text;
- (OakTextView *)tv;
- (NSUInteger)positionFromLineNumber:(NSUInteger)line andColumn:(NSUInteger)col;

@end

@implementation TextMateEmmetEditor

- (id)init {
	if (self = [super init]) {
		NSApp = [NSApplication sharedApplication];
		[[ZenCoding sharedInstance].jsc evalFunction:@"objcZenEditor.setAutoHandleIndent" withArguments:NO, nil];
	}
	
	return self;
}

- (OakTextView *)tv {
	return [NSApp targetForAction:@selector(insertSnippetWithOptions:)];
}

- (NSArray *)linesOfText:(NSString *)text {
	NSMutableArray *lines = [NSMutableArray array];
	unsigned numberOfLines, index, stringLength = [text length];
	NSRange lineRange;
	for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++) {
		lineRange = [text lineRangeForRange:NSMakeRange(index, 0)];
		[lines addObject:[NSValue valueWithRange:lineRange]];
		
		index = NSMaxRange(lineRange);
	}
	
	return lines;
}

- (NSUInteger)positionFromLineNumber:(NSUInteger)line andColumn:(NSUInteger)col {
	NSString *content = [self content];
	
	NSValue *lineRangeObj = [[self linesOfText:content] objectAtIndex:line];
	if (lineRangeObj == nil) {
		return 0;
	}
	
	NSRange lineRange = [lineRangeObj rangeValue];
	NSString *lineContent = [content substringWithRange:lineRange];
	
	if (col > 0) {
		const char* cStr = [lineContent UTF8String];
		char strBytes[col + 1];
		memset(strBytes, 0, sizeof(strBytes));
		strncpy(strBytes, cStr, col);
		
		NSString *prefix = [NSString stringWithCString:strBytes encoding:NSUTF8StringEncoding];
		if ([prefix length]) {
			return lineRange.location + prefix.length;
		}
	}
	
	return lineRange.location;
}

- (NSUInteger) caretPos {
	NSRange sel = [self selectionRange];
	return sel.location;
}

- (void)setCaretPos:(NSUInteger)caretPos {
	[self setSelectionRange:NSMakeRange(caretPos, 0)];
}

- (NSRange)selectionRange {
	NSDictionary *env = [[self tv] environmentVariables];
	NSString *startLine, *startChar, *endLine, *endChar;
	if ([env objectForKey:@"TM_INPUT_START_LINE_INDEX"]) {
		startLine = [env objectForKey:@"TM_INPUT_START_LINE"];
		startChar = [env objectForKey:@"TM_INPUT_START_LINE_INDEX"];
	} else {
		startLine = [env objectForKey:@"TM_LINE_NUMBER"];
		startChar = [env objectForKey:@"TM_LINE_INDEX"];
	}
	
	endLine = [env objectForKey:@"TM_LINE_NUMBER"];
	endChar = [env objectForKey:@"TM_LINE_INDEX"];
	
	NSUInteger start = [self positionFromLineNumber:[startLine integerValue] - 1 andColumn:[startChar integerValue]];
	NSUInteger end = [self positionFromLineNumber:[endLine integerValue] - 1 andColumn:[endChar integerValue]];
	
	return NSMakeRange(start, end - start);
}

- (void)setSelectionRange:(NSRange)range {
    OakTextView *tv = [self tv];
	TMLocation loc = convertRangeToLocation(range, [self content]);
	[tv goToLineNumber:[NSNumber numberWithInteger:loc.startLine]];
	[tv goToColumnNumber:[NSNumber numberWithInteger:loc.startCol]];
	[tv selectToLine:[NSNumber numberWithInteger:loc.endLine] andColumn:[NSNumber numberWithInteger:loc.endCol]];
}

- (NSRange)currentLineRange {
	NSDictionary *env = [[self tv] environmentVariables];
	NSString *line;
	if ([env objectForKey:@"TM_INPUT_START_LINE"]) {
		line = [env objectForKey:@"TM_INPUT_START_LINE"];
	} else {
		line = [env objectForKey:@"TM_LINE_NUMBER"];
	}
	
	NSValue *lineRangeObj = [[self linesOfText:[self content]] objectAtIndex:[line integerValue] - 1];
	return [lineRangeObj rangeValue];
}

- (NSString *)currentLine {
	NSRange curLineRange = [self currentLineRange];
	return [[self content] substringWithRange:curLineRange];
}

- (NSString *)content {
	return [[self tv] stringValue];
}

- (NSString *)syntax {
	return @"html";
}

- (NSString *)profileName {
	return @"xhtml";
}

- (NSString *)selection {
	NSDictionary *env = [[self tv] environmentVariables];
	if ([env objectForKey:@"TM_SELECTED_TEXT"]) {
		return [env objectForKey:@"TM_SELECTED_TEXT"];
	}
	
	return @"";
}

- (void)replaceContentWithValue:(NSString *)value from:(NSUInteger)start to:(NSUInteger)end withoutIndentation:(BOOL)indent {
	// check if range is in bounds
	OakTextView *tv = [self tv];
	if (end <= [[self content] length]) {
		self.selectionRange = NSMakeRange(start, end - start);
		[tv insertSnippetWithOptions:[NSDictionary dictionaryWithObjectsAndKeys:value, @"content", nil]];
	}
}

- (NSString *)prompt:(NSString *)label {
	return [ZenCodingPromptDialogController promptForWindow:[[self tv] window] withLabel:label];
}

- (NSString *)filePath {
	NSDictionary *env = [[self tv] environmentVariables];
	return [env objectForKey:@"TM_FILEPATH"];
}

@end
