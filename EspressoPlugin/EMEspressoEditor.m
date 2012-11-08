//
//  EspressoEmmetEditor.m
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 8/25/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "EMEspressoEditor.h"
#import "Emmet.h"
#import "EMPromptDialogController.h"

#import <EspressoSDK.h>

@implementation EMEspressoEditor

- (id)initWithContext:(NSObject *)context {
	ctx = [context retain];
	return [super init];
}

- (NSUInteger) caretPos {
	NSRange sel = [self selectionRange];
	return sel.location;
}

- (void)setCaretPos:(NSUInteger)caretPos {
	[self setSelectionRange:NSMakeRange(caretPos, 0)];
}

- (NSRange) selectionRange {
	return [[ctx.selectedRanges objectAtIndex:0] rangeValue];
}

- (void) setSelectionRange:(NSRange)range {
	ctx.selectedRanges = [NSArray arrayWithObject:[NSValue valueWithRange:range]];
}

- (NSString *)selection {
	return [[self content] substringWithRange:[self selectionRange]];
}

- (NSString *)content {
    return ctx.string;
}

- (NSString *)syntax {
	NSDictionary *knownSyntaxes = [NSDictionary dictionaryWithObjectsAndKeys:
								   @"css, css *", @"css",
								   @"scss, scss *", @"scss",
								   @"sass, sass *", @"sass",
								   @"less, less *", @"less",
								   @"xsl, xsl *", @"xsl",
								   @"xml, xml *", @"xml",
								   @"haml, haml *", @"haml", nil];
	

	SXZone *zone = ctx.syntaxTree.rootZone;
	NSRange curRange = [self selectionRange];
	
//	Having some issues with LESS.sugar: none of the defined LESS selectors
//	matches *current* zone.
//	So, we actually need current zone for HTML syntax only to get the embedded
//	syntax (CSS, JS), in other cases, just using the root zone
	
	SXSelector *htmlSel = [SXSelector selectorWithString:@"html, html *"];
	if ([htmlSel matches:zone] && [ctx.string length] != curRange.location) {
		zone = [ctx.syntaxTree zoneAtCharacterIndex:curRange.location];
	}
	
	NSString __block *syntax = @"html";
	[knownSyntaxes enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *val, BOOL *stop) {
		SXSelector *s = [SXSelector selectorWithString:val];
		
		if ([s matches:zone]) {
			syntax = key;
			*stop = YES;
		}
	}];
	
	return syntax;
}

- (NSString *)profileName {
	NSString *syntax = [self syntax];
	if ([syntax isEqualToString:@"xml"] || [syntax isEqualToString:@"xsl"]) {
		return @"xml";
	}
	
	return @"line";
}

- (NSRange)currentLineRange {
	id<CELineStorage> ls = ctx.lineStorage;
	return [ls lineRangeForIndex:[self caretPos]];
}

- (NSString *)currentLine {
	return [[self content] substringWithRange:[self currentLineRange]];
}

- (void)replaceContentWithValue:(NSString *)value from:(NSUInteger)start to:(NSUInteger)end withoutIndentation:(BOOL)noIndent {
	// check if range is in bounds
	if (end <= [[self content] length]) {
		self.selectionRange = NSMakeRange(start, end - start);
		NSUInteger options = CETextOptionNormalizeLineEndingCharacters | CETextOptionNormalizeIndentationCharacters;
		if (!noIndent) {
			options |= CETextOptionNormalizeIndentationLevel;
		}

		[ctx insertTextSnippet:[CETextSnippet snippetWithString:value] options:options];
	}
}

- (NSString *)prompt:(NSString *)label {
	return [EMPromptDialogController promptForWindow:[ctx windowForSheet] withLabel:label];
}

- (NSString *)filePath {
	NSObject *doc = ctx.documentContext;
	return [doc.fileURL path];
}


- (void)dealloc {
	[ctx release];
	[super dealloc];
}

@end
