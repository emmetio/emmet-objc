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
	NSObjectController *outputContext;
	
	NSMutableDictionary *outputPreferences;
}

@property (assign) IBOutlet NSArrayController *syntaxList;
@property (assign) IBOutlet NSTextField *extensionsPathField;
@property (assign) IBOutlet NSArrayController *snippets;
@property (assign) IBOutlet NSTableView *snippetsView;
@property (assign) IBOutlet NSPopUpButton *syntaxPopup;
@property (assign) IBOutlet NSObjectController *outputContext;

+ (void)loadDefaults;

- (IBAction)pickExtensionsFolder:(id)sender;
- (IBAction)addSnippet:(id)sender;
- (IBAction)removeSnippet:(id)sender;

@end
