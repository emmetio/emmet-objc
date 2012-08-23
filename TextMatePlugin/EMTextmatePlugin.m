//
//  ZCTextmatePlugin.m
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 8/11/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "EMTextmatePlugin.h"
#import "JSCocoaDelegate.h"
#import "TextMateEmmetEditor.h"

static NSString * const EmmetBundleIdentifier = @"ru.chikuyonok.EmmetTextmate";

@interface EMTextmatePlugin ()
- (void)performMenuAction:(id)sender;
- (void)showPreferences:(id)sender;
@end

@implementation EMTextmatePlugin

+ (NSBundle *)bundle {
	return [NSBundle bundleWithIdentifier:EmmetBundleIdentifier];
}

- (id)initWithPlugInController:(id <TMPlugInController>)aController {
	self = [super init];
	if (self != nil) {
		NSApp = [NSApplication sharedApplication];
		NSBundle *bundle = [EMTextmatePlugin bundle];
		
		[ZenCoding addCoreFile:[bundle pathForResource:@"textmate-bootstrap" ofType:@"js"]];
		[ZenCoding setJSContextDelegateClass:[JSCocoaDelegate class]];
		
		editor = [TextMateEmmetEditor new];
		[[ZenCoding sharedInstance] setContext:editor];
		
		[self installMenuItems];
	}
	return self;
}

- (void)installMenuItems {
	NSString *keyboardShortcutsPlist = [[EMTextmatePlugin bundle] pathForResource:@"KeyboardShortcuts" ofType:@"plist"];
	NSDictionary *shortcuts = [NSDictionary dictionaryWithContentsOfFile:keyboardShortcutsPlist];
	NSMenu *menu = [[ZenCoding sharedInstance] actionsMenuWithAction:@selector(performMenuAction:) keyboardShortcuts:shortcuts forTarget:self];
	[menu addItem:[NSMenuItem separatorItem]];
	
	NSMenuItem *preferencesItem = [[NSMenuItem alloc] initWithTitle:@"Preferences..." action:@selector(showPreferences:) keyEquivalent:@""];
	preferencesItem.target = self;
	[menu addItem:preferencesItem];
	[preferencesItem release];
	
	NSMenuItem *rootItem = [[NSApp mainMenu] addItemWithTitle:@"Emmet" action:nil keyEquivalent:@""];
	
	rootItem.submenu = menu;
}

- (void)performMenuAction:(id)sender {
//	OakTextView *tv = [NSApp targetForAction:@selector(insertSnippetWithOptions:)];
//	NSLog(@"Env: %@", [tv environmentVariables]);
//	NSLog(@"XML: %@", [tv xmlRepresentation]);
	[[ZenCoding sharedInstance] performMenuAction:sender];
}

- (void)showPreferences:(id)sender {
	if (prefs == nil) {
		prefs = [[ZCBasicPreferencesWindowController alloc] init];
	}
	
	[prefs showWindow:self];
}

- (void)dealloc {
	[editor release];
	[super dealloc];
}


@end