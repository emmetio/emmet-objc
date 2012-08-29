//
//  ZCTextmatePlugin.m
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 8/11/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "EMTextmatePlugin.h"
#import "JSCocoaDelegate.h"
#import "EMTextMateEditor.h"

static NSString * const EmmetBundleIdentifier = @"io.emmet.EmmetTextmate";

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
		
		[Emmet addCoreFile:[bundle pathForResource:@"textmate-bootstrap" ofType:@"js"]];
		[Emmet setJSContextDelegateClass:[JSCocoaDelegate class]];
		
		editor = [EMTextMateEditor new];
		[[Emmet sharedInstance] setContext:editor];
		
		[self installMenuItems];
	}
	return self;
}

- (void)installMenuItems {
	NSString *keyboardShortcutsPlist = [[EMTextmatePlugin bundle] pathForResource:@"KeyboardShortcuts" ofType:@"plist"];
	NSDictionary *shortcuts = [NSDictionary dictionaryWithContentsOfFile:keyboardShortcutsPlist];
	NSMenu *menu = [[Emmet sharedInstance] actionsMenuWithAction:@selector(performMenuAction:) keyboardShortcuts:shortcuts forTarget:self];
	[menu addItem:[NSMenuItem separatorItem]];
	
	NSMenuItem *preferencesItem = [[NSMenuItem alloc] initWithTitle:@"Preferences..." action:@selector(showPreferences:) keyEquivalent:@""];
	preferencesItem.target = self;
	[menu addItem:preferencesItem];
	[preferencesItem release];
	

	NSMenuItem *rootItem = [[NSMenuItem alloc] initWithTitle:@"Emmet" action:nil keyEquivalent:@""];
	
	rootItem.submenu = menu;
	
	NSMenu *mainMenu = [NSApp mainMenu];
	NSUInteger refIndex = [mainMenu indexOfItemWithTitle:@"Window"];
	if (refIndex != -1) {
		[mainMenu insertItem:rootItem atIndex:refIndex];
	} else {
		[mainMenu addItem:rootItem];
	}
	
	[rootItem release];
}

- (void)performMenuAction:(id)sender {
	[[Emmet sharedInstance] performMenuAction:sender];
}

- (void)showPreferences:(id)sender {
	if (prefs == nil) {
		prefs = [[EMBasicPreferencesWindowController alloc] init];
		[prefs hideTabExpanderControl];
	}
	
	[prefs showWindow:self];
}

- (void)dealloc {
	[editor release];
	[super dealloc];
}


@end