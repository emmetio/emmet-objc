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

- (NSDictionary *)openEditDialog:(NSDictionary *)editObj forWindow:(NSWindow *)wnd {
	NSWindow *w = [self window];
	
	editObject = [editObj copy];
	
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
	
	// return initial value
	[editObject release];
	return editObj;
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
