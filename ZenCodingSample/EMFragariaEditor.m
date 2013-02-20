//
//  EMFragariaEditor.m
//  Emmet
//
//  Created by Sergey Chikuyonok on 1/6/13.
//  Copyright (c) 2013 Аймобилко. All rights reserved.
//

#import "EMFragariaEditor.h"
#import "NSTextView+EmmetEditor.h"

@implementation EMFragariaEditor

- (id)initWithBackend:(MGSFragaria *)backend {
	if (self = [super init]) {
		_backend = [backend retain];
		tv = [backend objectForKey:ro_MGSFOTextView];
	}
	
	return self;
}

- (NSUInteger) caretPos {
	return tv.caretPos;
}

- (void)setCaretPos:(NSUInteger)caretPos {
	tv.caretPos = caretPos;
}

- (NSRange) selectionRange {
    return tv.selectionRange;
}

- (void) setSelectionRange:(NSRange)range {
    tv.selectionRange = range;
}

- (NSRange)currentLineRange {
	return [tv currentLineRange];
}
- (NSString *)currentLine {
	return [tv currentLine];
}
- (NSString *)content {
	return [tv content];
}

- (NSString *)syntax {
	NSString *syntax = [_backend objectForKey:MGSFOSyntaxDefinitionName];
	return [syntax lowercaseString];
}
- (NSString *)profileName {
	return nil;
}

- (NSString *)selection {
	return [tv selection];
}

- (void)replaceContentWithValue:(NSString *)value from:(NSUInteger)start to:(NSUInteger)end withoutIndentation:(BOOL)indent {
	[tv replaceContentWithValue:value from:start to:end withoutIndentation:indent];
}

- (NSString *)prompt:(NSString *)label {
	return [tv prompt:label];
}

- (NSString *)filePath {
	return @"/Users/Sergey/Projects/zc-ext/sample.css";
//	return [[NSFileManager defaultManager] currentDirectoryPath];
}

- (void)dealloc {
	[_backend release];
	[super dealloc];
}

@end
