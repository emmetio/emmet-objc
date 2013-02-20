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

#define TabKeyCode 48
#define NoFlags (NSShiftKeyMask | NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask)

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
		
		// Implementing abbreviation expand by Tab key
		// This logic must be implemented for each editor independently,
		// because it should also check if current editor state allows Tab key
		// interception (e.g. if there's no tabstops in editor)
		[NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *event) {
			// handle event only for key text view
			NSWindow *wnd = [[editor tv] window];
			if ([wnd isKeyWindow] && [event keyCode] == TabKeyCode && ([event modifierFlags] & NoFlags) == 0 && [[NSUserDefaults standardUserDefaults] boolForKey:@"expandWithTab"]) {
				// if abbreviation expanded successfully, stop event.
				// otherwise, pass it further
				if ([[Emmet sharedInstance] runAction:@"expand_abbreviation"]) {
					return (NSEvent *)nil;
				}
			}
			
			return event;
		}];
		
		// init updater
		updater = [SUUpdater updaterForBundle:bundle];
		[updater setAutomaticallyChecksForUpdates:YES];
		[updater resetUpdateCycle];
		
		[self installMenuItems];
	}
	return self;
}

- (void)installMenuItems {
	NSString *keyboardShortcutsPlist = [[EMTextmatePlugin bundle] pathForResource:@"KeyboardShortcuts" ofType:@"plist"];
	NSDictionary *shortcuts = [NSDictionary dictionaryWithContentsOfFile:keyboardShortcutsPlist];
	NSMenu *menu = [[Emmet sharedInstance] actionsMenuWithAction:@selector(performMenuAction:) keyboardShortcuts:shortcuts forTarget:self];
	[menu addItem:[NSMenuItem separatorItem]];

	// create Preferences... item
	NSMenuItem *preferencesItem = [[NSMenuItem alloc] initWithTitle:@"Preferences..." action:@selector(showPreferences:) keyEquivalent:@""];
	preferencesItem.target = self;
	[menu addItem:preferencesItem];
	[preferencesItem release];
	
	// create Check for updates... menu item
	NSMenuItem *updatesItem = [[NSMenuItem alloc] initWithTitle:@"Check for updates..." action:@selector(checkForUpdates:) keyEquivalent:@""];
	updatesItem.target = updater;
	[menu addItem:updatesItem];
	[updatesItem release];

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
//		[prefs hideTabExpanderControl];
	}
	
	[prefs showWindow:self];
}

- (void)dealloc {
	[editor release];
	[super dealloc];
}


@end