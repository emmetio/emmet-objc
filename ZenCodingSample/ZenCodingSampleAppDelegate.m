//
//  ZenCodingSampleAppDelegate.m
//  ZenCodingSample
//
//  Created by Сергей Чикуёнок on 2/18/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import "ZenCodingSampleAppDelegate.h"
#import "Emmet.h"
#import "EMPromptDialogController.h"
#import "JSCocoaDelegate.h"

#define TabKeyCode 48
#define NoFlags (NSShiftKeyMask | NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask)

@implementation ZenCodingSampleAppDelegate

@synthesize window;

+ (void)initialize {
	[Emmet setJSContextDelegateClass:[JSCocoaDelegate class]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Implementing abbreviation expand by Tab key
	// This logic should be implemented for each editor independently,
	// because it should also check if current editor state allow Tab key
	// interception (e.g. if it contains tabstops)
	[NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *event) {
		// handle event only for key text view
		if ([window isKeyWindow] && [window firstResponder] == textArea) {
			if ([event keyCode] == TabKeyCode && ([event modifierFlags] & NoFlags) == 0 && [[NSUserDefaults standardUserDefaults] boolForKey:ExpandWithTabKey]) {
				
				Emmet *zc = [Emmet sharedInstance];
				[zc setContext:textArea];
				
				// if abbreviation expanded successfully, stop event.
				// otherwise, pass it further
				if ([zc runAction:@"expand_abbreviation"]) {
					return (NSEvent *)nil;
				}
			}
		}
		
		return event;
	}];
	
	// add actions as global menu item
	
	NSString *keyboardShortcutsPlist = [[NSBundle mainBundle] pathForResource:@"KeyboardShortcuts" ofType:@"plist"];
	NSDictionary *shortcuts = [NSDictionary dictionaryWithContentsOfFile:keyboardShortcutsPlist];
	
	NSMenu *mainMenu = [NSApp mainMenu];
	NSMenu *actionsMenu = [[Emmet sharedInstance] actionsMenuWithAction:@selector(performMenuAction:) keyboardShortcuts:shortcuts forTarget:self];
	NSMenuItem *actionsItem = [[NSMenuItem alloc] initWithTitle:[actionsMenu title] action:NULL keyEquivalent:@""];
	[actionsItem setSubmenu:actionsMenu];
	[mainMenu insertItem:actionsItem atIndex:4];
	
	[actionsItem release];
}

- (void)performMenuAction:(id)sender {
	Emmet *zc = [Emmet sharedInstance];
	[zc setContext:textArea];
	[zc performMenuAction:sender];
}

- (IBAction)showPreferences:(id)sender {
	if (prefs == nil) {
		prefs = [[EMBasicPreferencesWindowController alloc] init];
	}
	
	[prefs showWindow:self];
}

@end
