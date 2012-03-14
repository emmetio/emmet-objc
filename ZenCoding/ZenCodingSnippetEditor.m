//
//  ZenCodingSnippetEditor.m
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 3/13/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "ZenCodingSnippetEditor.h"

@interface ZenCodingSnippetEditor ()
- (void)closeDialogWithCode:(int)code;
- (IBAction)performOK:(id)sender;
- (IBAction)performCancel:(id)sender;
- (BOOL)isEmpty:(NSDictionary *)snippet;
- (NSDictionary *)normalize:(NSDictionary *)snippet;
@end

@implementation ZenCodingSnippetEditor

- (id)init {
    return [super initWithWindowNibName:@"SnippetEditor"];
}

- (id)initWithWindow:(NSWindow *)window {
	editObject = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
				  @"", @"name", 
				  @"", @"syntax", 
				  @"", @"value", nil];
	
	return [super initWithWindow:window];
}

- (NSDictionary *)openAddDialogForWindow:(NSWindow *)wnd {
	return [self openEditDialog:nil forWindow:wnd];
}

- (NSDictionary *)openEditDialog:(NSDictionary *)obj forWindow:(NSWindow *)wnd {
	// copy edited objet value or reset the current object
	[editObject enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
		NSString *val = [obj objectForKey:key];
		[editObject setValue:(val != nil) ? val : @"" forKey:key];
	}];
	
	NSWindow *w = [self window];
	[NSApp beginSheet:w
	   modalForWindow:wnd
		modalDelegate:nil 
	   didEndSelector:nil
		  contextInfo:nil];
	
	NSInteger code = [NSApp runModalForWindow: w];
	[NSApp endSheet: w];
    [w orderOut: self];
	
	if (code == SNIPPET_EDITOR_OK) {
		NSDictionary *result = [self normalize:editObject];
		if (![self isEmpty:result])
			return result;
		
		[result release];
	}
	
	
	// return nil to indicate that user cancelled operation 
	// or has invalid snippet
	return nil;
}

- (void)closeDialogWithCode:(int)code {
	[[self window] makeFirstResponder:nil];
	[NSApp stopModalWithCode:code];
}

- (IBAction)performOK:(id)sender {
	[self closeDialogWithCode:SNIPPET_EDITOR_OK];
}

- (IBAction)performCancel:(id)sender {
	[self closeDialogWithCode:SNIPPET_EDITOR_CANCEL];
}

- (BOOL)isEmpty:(NSDictionary *)snippet {
	NSString *name = [snippet valueForKey:@"name"];
	NSString *value = [snippet valueForKey:@"value"];
	return [name isEqual:@""] || [value isEqual:@""];
}

- (NSDictionary *)normalize:(NSDictionary *)snippet {
	
	NSMutableDictionary *normalizedSnippet = [[NSMutableDictionary alloc] initWithDictionary:snippet];
	
	NSString *snippetName = [normalizedSnippet valueForKey:@"name"];
	NSString *trimmedName = [snippetName stringByTrimmingCharactersInSet:
							 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	[normalizedSnippet setValue:trimmedName forKey:@"name"];
	return normalizedSnippet;
}

- (BOOL)windowShouldClose:(NSWindow *)window {
    return [window makeFirstResponder:nil]; // validate editing
}

- (void)dealloc {
	[editObject release];
	[super dealloc];
}

@end
