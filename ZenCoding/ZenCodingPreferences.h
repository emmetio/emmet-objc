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
	NSTextField *inlineBreaksField;
}

@property (readonly, retain) NSArray *outputPrefs;
@property (readonly, retain) NSDictionary *outputPrefsDict;
@property (assign) IBOutlet NSArrayController *syntaxList;
@property (assign) IBOutlet NSTextField *extensionsPathField;
@property (assign) IBOutlet NSArrayController *snippets;

- (IBAction)pickExtensionsFolder:(id)sender;
+ (void)loadDefaults;
- (IBAction)addSnippet:(id)sender;

@end
