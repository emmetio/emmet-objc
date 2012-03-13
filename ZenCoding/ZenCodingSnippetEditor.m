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
@end

@implementation ZenCodingSnippetEditor

- (id)init {
    return [super initWithWindowNibName:@"SnippetEditor"];
}

- (NSDictionary *)openAddDialogForWindow:(NSWindow *)wnd {
	NSDictionary *editObj = [NSDictionary dictionaryWithObjectsAndKeys:
							 @"", @"name", 
							 @"", @"syntax", 
							 @"", @"value", nil];
	
	return [self openEditDialog:editObj forWindow:wnd];
}

- (NSDictionary *)openEditDialog:(NSDictionary *)editObj forWindow:(NSWindow *)wnd {
	NSWindow *w = [self window];
	
	editObject = [NSMutableDictionary dictionaryWithDictionary:editObj];
	
	[NSApp beginSheet:w
	   modalForWindow:wnd
		modalDelegate:nil 
	   didEndSelector:nil
		  contextInfo:nil];
	
	NSInteger code = [NSApp runModalForWindow: w];
	[NSApp endSheet: w];
    [w orderOut: self];
	
	if (code == SNIPPET_EDITOR_OK) {
		return editObject;
	}
	
	// return nil to indicate that user cancelled operation
	[editObject release];
	return nil;
}

- (void)closeDialogWithCode:(int)code {
	[NSApp stopModalWithCode:code];
}

- (IBAction)performOK:(id)sender {
	[self closeDialogWithCode:SNIPPET_EDITOR_OK];
}

- (IBAction)performCancel:(id)sender {
	[self closeDialogWithCode:SNIPPET_EDITOR_CANCEL];
}

@end
