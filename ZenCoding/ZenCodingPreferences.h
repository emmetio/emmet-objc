//
//  ZenCodingPreferences.h
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 3/9/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZenCodingCorePreferencesController.h"

@interface ZenCodingPreferences : NSWindowController {
    NSButton *pickExtensionsFolder;
	NSArrayController *syntaxList;
	NSTextField *extensionsPathField;
	NSTableView *snippetsView;
	NSTableView *abbreviationsView;
	NSTableView *variablesView;
	NSPopUpButton *syntaxPopup;
	NSObjectController *outputContext;
	NSArrayController *snippetsController;
	NSArrayController *abbreviationsController;
	NSArrayController *variablesController;
	NSArrayController *preferencesController;
	NSTableView *corePreferencesView;
	
	NSMutableDictionary *outputPreferences;
	
	// pointer to currently edited array controller (snippets or abbreviations)
	NSArrayController *contextController;
	ZenCodingCorePreferencesController *_prefsController;
}

@property (assign) IBOutlet NSArrayController *syntaxList;
@property (assign) IBOutlet NSTextField *extensionsPathField;
@property (assign) IBOutlet NSTableView *snippetsView;
@property (assign) IBOutlet NSTableView *abbreviationsView;
@property (assign) IBOutlet NSTableView *variablesView;
@property (assign) IBOutlet NSPopUpButton *syntaxPopup;
@property (assign) IBOutlet NSObjectController *outputContext;
@property (assign) IBOutlet NSArrayController *snippetsController;
@property (assign) IBOutlet NSArrayController *abbreviationsController;
@property (assign) IBOutlet NSArrayController *variablesController;
@property (assign) IBOutlet NSArrayController *preferencesController;
@property (assign) IBOutlet NSTableView *corePreferencesView;


+ (void)loadDefaults;
+ (void)resetDefaults;

- (IBAction)pickExtensionsFolder:(id)sender;
- (IBAction)addSnippet:(id)sender;
- (IBAction)editSnippet:(id)sender;
- (IBAction)removeSnippet:(id)sender;

@end
