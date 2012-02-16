//
//  ZenCodingAppDelegate.m
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 1/12/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import "ZenCodingAppDelegate.h"
#import "JSCocoa.h"
#import "NSTextView+ZenEditor.h"
#import "ZenCodingTextProcessor.h"

@implementation ZenCodingAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	
    // Insert code here to initialize your application
}

- (IBAction)showCaretPos:(id)sender {
	NSLog(@"Caret pos: %lu", [textArea caretPos]);
}
- (IBAction)showSelectionRange:(id)sender {
	NSLog(@"Selection range: %@", NSStringFromRange([textArea selectionRange]));
}
- (IBAction)showCurrentLineRange:(id)sender {
	NSLog(@"Current line range: %@", NSStringFromRange([textArea currentLineRange]));
}
- (IBAction)showCurrentLine:(id)sender {
	NSLog(@"Current line: %@", [textArea currentLine]);
}
- (IBAction)showContent:(id)sender {
	NSLog(@"Content: %@", [textArea content]);
}
- (IBAction)showSyntax:(id)sender {
	NSLog(@"Syntax: %@", [textArea syntax]);
}
- (IBAction)showSelection:(id)sender {
	NSLog(@"Selection: %@", [textArea selection]);
}
- (IBAction)replaceText:(id)sender {
	[textArea replaceContentWithValue:@"Hello" from:1 to:3 withoutIndentation:YES];
}
- (IBAction)expandAbbreviation:(id)sender {
	ZenCoding *zc = [ZenCoding sharedInstance];
	[zc setContext:textArea];
	[zc runAction:@"expand_abbreviation"];
}

- (void)dealloc {
	[super dealloc];
}

@end