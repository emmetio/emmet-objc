//
//  Created by Sergey on 2/17/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "EMPromptDialogController.h"

@implementation EMPromptDialogController
@synthesize label;
@synthesize inputField;

- (id)init {
	return [self initWithWindowNibName:@"PromptDialog"];
}

- (IBAction)performOK:(id)sender {
	[NSApp stopModalWithCode:MODAL_ACTION_OK];
}

- (IBAction)performCancel:(id)sender {
	[NSApp stopModalWithCode:MODAL_ACTION_CANCEL];
}

+ (NSString *)prompt:(NSString *)labelText {
	return [EMPromptDialogController promptForWindow:[NSApp mainWindow] withLabel:labelText];
}

+ (NSString *)promptForWindow:(NSWindow *)wnd withLabel :(NSString *)labelText {
	EMPromptDialogController *dialog = [EMPromptDialogController new];
	NSString *value = [dialog promptForWindow:wnd withLabel:labelText];
	[dialog release];
	return value;
}

- (NSString *)promptWithLabel:(NSString *)labelText {
	return [self promptForWindow:[NSApp mainWindow] withLabel:labelText];
}

- (NSString *)promptForWindow:(NSWindow *)wnd withLabel:(NSString *)labelText {
	NSWindow *w = [self window];
	if (labelText != nil)
		[label setStringValue:labelText];
	else
		[label setStringValue:MODAL_DEFAULT_LABEL];
	
	[NSApp beginSheet:w
	   modalForWindow:wnd
		modalDelegate:nil 
	   didEndSelector:nil
		  contextInfo:nil];
	
	NSInteger code = [NSApp runModalForWindow: w];
	[NSApp endSheet: w];
    [w orderOut: self];
	
	if (code == MODAL_ACTION_OK) {
		return [inputField stringValue];
	}
	
	return nil;
}

@end
