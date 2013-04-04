//
//  TextMateEmEditor.m
//
//  Created by Sergey Chikuyonok on 8/11/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "EMTextMateEditor.h"
#import "Emmet.h"
#import "EMPromptDialogController.h"

TMLocation convertRangeToLocation(NSRange range, NSString *string) {
	NSUInteger numberOfLines, index, stringLength = [string length];
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

@interface OTVStatusBar

@property (nonatomic, assign) NSString* grammarName;

@end

@implementation NSString (EmmetUtils)

- (BOOL)containsSubstring:(NSString *)str {
	return [self rangeOfString:str].location != NSNotFound;
}

@end

@interface EMTextMateEditor ()

- (NSArray *)linesOfText:(NSString *)text;
- (NSUInteger)positionFromLineNumber:(NSUInteger)line andColumn:(NSUInteger)col;
- (NSString *)matchedSyntax;
- (int)apiVersion;

@end

@implementation EMTextMateEditor

- (id)init {
	if (self = [super init]) {
		NSApp = [NSApplication sharedApplication];
		[[Emmet sharedInstance].jsc evalFunction:@"objcEmmetEditor.setAutoHandleIndent" withArguments:NO, nil];
	}
	
	return self;
}

- (OakTextView *)tv {
	return [NSApp targetForAction:@selector(insertSnippetWithOptions:)];
}

- (int)apiVersion {
	if ([[self tv] respondsToSelector:@selector(delegate)]) {
		return 2;
	}
	
	return 1;
}

- (NSArray *)linesOfText:(NSString *)text {
	NSMutableArray *lines = [NSMutableArray array];
	NSUInteger numberOfLines, index, stringLength = [text length];
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

- (NSUInteger)caretPos {
	NSRange sel = [self selectionRange];
	return sel.location;
}

- (void)setCaretPos:(NSUInteger)caretPos {
	[self setSelectionRange:NSMakeRange(caretPos, 0)];
}

- (NSRange)selectionRange {
	OakTextView *tv = [self tv];
	
	if ([self apiVersion] == 1) {
		// TextMate 1.x API
		NSDictionary *env = [tv environmentVariables];
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
	
	// TextMate 2.x API
	return [[tv accessibilityAttributeValue:NSAccessibilitySelectedTextRangeAttribute] rangeValue];
}

- (void)setSelectionRange:(NSRange)range {
    OakTextView *tv = [self tv];
	if ([self apiVersion] == 1) {
		TMLocation loc = convertRangeToLocation(range, [self content]);
		[tv goToLineNumber:[NSNumber numberWithInteger:loc.startLine]];
		[tv goToColumnNumber:[NSNumber numberWithInteger:loc.startCol]];
		[tv selectToLine:[NSNumber numberWithInteger:loc.endLine] andColumn:[NSNumber numberWithInteger:loc.endCol]];
	} else {
		[tv accessibilitySetValue:[NSValue valueWithRange:range] forAttribute:NSAccessibilitySelectedTextRangeAttribute];
	}
}

- (NSRange)currentLineRange {
	NSString *content = [self content];
	NSRange sel = [self selectionRange];
	return [content lineRangeForRange:NSMakeRange(sel.location, 0)];
}

- (NSString *)currentLine {
	NSRange curLineRange = [self currentLineRange];
	return [[self content] substringWithRange:curLineRange];
}

- (NSString *)content {
	OakTextView *tv = [self tv];
	if ([tv respondsToSelector:@selector(string)]) {
		return [tv string];
	}
	return [[self tv] stringValue];
}

- (NSString *)matchedSyntax {
	// TextMate 2 API
	if ([self apiVersion] == 2) {
		// a very, VERY hacky way to get syntax for current document:
		// find status bar and get grammar name
		NSView *docView = [NSApp targetForAction:@selector(setThemeWithUUID:)];
		if (docView) {
			NSArray *views = [docView subviews];
			for (NSView *v in views) {
				if ([v respondsToSelector:@selector(grammarName)]) {
					return [v performSelector:@selector(grammarName)];

				}
			}
		}
	} else {
		// TextMate 1.x
		OakTextView *tv = [self tv];
		NSDictionary *env = [tv environmentVariables];
		NSString *scope = [env objectForKey:@"TM_SCOPE"];
		
		NSArray *syntaxes = [NSArray arrayWithObjects:@"xsl", @"xml", @"haml", @"css", @"less", @"less", @"scss", @"sass", @"html", nil];
		NSString *syntax = nil;
		for (int i = 0; i < [syntaxes count]; i++) {
			syntax = [syntaxes objectAtIndex:i];
			if ([scope containsSubstring:syntax]) {
				return syntax;
			}
		}
	}
	
	return nil;
}

- (NSString *)syntax {
	NSString *syntax = [self matchedSyntax];
	if (!syntax) {
		syntax = @"html";
	}
	
	return [syntax lowercaseString];
}

- (NSString *)profileName {
	NSString *syntax = [self matchedSyntax];
	
	if (!syntax) {
		return @"line";
	}
	
	return nil;
}

- (NSString *)selection {
	OakTextView *tv = [self tv];
	if ([tv respondsToSelector:@selector(selectionString)]) {
		return tv.selectionString;
	}
	
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
	return [EMPromptDialogController promptForWindow:[[self tv] window] withLabel:label];
}

- (NSString *)filePath {
	NSDictionary *env = [[self tv] environmentVariables];
	return [env objectForKey:@"TM_FILEPATH"];
}

@end
