//
//  ZenCodingPreferences.h
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 3/9/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ZenCodingPreferences : NSWindowController {
    NSButton *pickExtensionsFolder;
	NSArrayController *syntaxList;
	NSTextField *extensionsPathField;
	NSArrayController *snippets;
	NSTableView *snippetsView;
	NSPopUpButton *syntaxPopup;
	NSTextField *inlineBreaksField;
	NSDictionaryController *sampleController;
	NSObjectController *outputContext;
	NSDictionaryController *outputPreferences;
}

@property (assign) IBOutlet NSArrayController *syntaxList;
@property (assign) IBOutlet NSTextField *extensionsPathField;
@property (assign) IBOutlet NSArrayController *snippets;
@property (assign) IBOutlet NSTableView *snippetsView;
@property (assign) IBOutlet NSPopUpButton *syntaxPopup;

- (IBAction)pickExtensionsFolder:(id)sender;
+ (void)loadDefaults;
- (IBAction)addSnippet:(id)sender;
- (IBAction)removeSnippet:(id)sender;
@property (assign) IBOutlet NSDictionaryController *sampleController;
- (IBAction)showDebugInfo:(id)sender;

@property (assign) IBOutlet NSObjectController *outputContext;
@property (assign) IBOutlet NSDictionaryController *outputPreferences;


@end
