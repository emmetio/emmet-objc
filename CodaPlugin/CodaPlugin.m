//
//  CodaSample.m
//  CodaSample
//
//  Created by Сергей Чикуёнок on 2/22/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import "CodaPlugin.h"
#import "CodaZenEditor.h"
#import "JSCocoaDelegate.h"
#import <ZenCoding/ZenCoding.h>

#define TabKeyCode 48
#define NoFlags (NSShiftKeyMask | NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask)

@interface CodaPlugin ()

- (id)initWithController:(CodaPlugInsController*)inController;
- (void)createMenu;
- (void)createCodaMenuItemsFromArray:(NSArray *)items forSubmenuWithTitle:(NSString *)submenu withShortcuts:(NSDictionary *)shortcuts;

@end

@implementation CodaPlugin

- (NSString*)name {
	return @"Zen Coding";
}

//2.0 and lower
- (id)initWithPlugInController:(CodaPlugInsController*)aController bundle:(NSBundle*)aBundle {
	keyboardShortcutsPlist = [aBundle pathForResource:@"KeyboardShortcuts" ofType:@"plist"];
	return [self initWithController:aController];
}


//2.0.1 and higher
- (id)initWithPlugInController:(CodaPlugInsController*)aController plugInBundle:(NSObject <CodaPlugInBundle> *)plugInBundle {
	keyboardShortcutsPlist = [plugInBundle pathForResource:@"KeyboardShortcuts" ofType:@"plist"];
    return [self initWithController:aController];
}

- (id)initWithController:(CodaPlugInsController *)aController {
	if ((self = [super init]) != nil) {
		controller = aController;
		[ZenCoding setJSContextDelegateClass:[JSCocoaDelegate class]];
		editor = [[CodaZenEditor alloc] initWithCodaView:nil];
		[[ZenCoding sharedInstance] setContext:editor];
		
		[self createMenu];
		
		
		// Implementing abbreviation expand by Tab key
		// This logic must be implemented for each editor independently,
		// because it should also check if current editor state allows Tab key
		// interception (e.g. if there's no tabstops in editor)
		[NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *event) {
			// handle event only for key text view
			NSWindow *wnd = [[controller focusedTextView:self] window];
			if ([wnd isKeyWindow] && [event keyCode] == TabKeyCode && ([event modifierFlags] & NoFlags) == 0 && [[NSUserDefaults standardUserDefaults] boolForKey:@"expandWithTab"]) {
				
				ZenCoding *zc = [ZenCoding sharedInstance];
				editor.tv = [controller focusedTextView:self];
				
				// if abbreviation expanded successfully, stop event.
				// otherwise, pass it further
				if ([zc runAction:@"expand_abbreviation"]) {
					return (NSEvent *)nil;
				}
			}
			
			return event;
		}];
	}
	
	return self;
}

- (void)createMenu {
	NSArray *actions = [[ZenCoding sharedInstance] actionsList];
	
	NSDictionary *shortcuts = nil;
	if (keyboardShortcutsPlist) {
		shortcuts = [NSDictionary dictionaryWithContentsOfFile:keyboardShortcutsPlist];
	}
	
	[self createCodaMenuItemsFromArray:actions forSubmenuWithTitle:nil withShortcuts:shortcuts];
	[controller registerActionWithTitle:@"Preferences..." target:self selector:@selector(showPreferences:)];
}

- (void)createCodaMenuItemsFromArray:(NSArray *)items forSubmenuWithTitle:(NSString *)submenu withShortcuts:(NSDictionary *)shortcuts {
	[items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSDictionary *item = (NSDictionary *)obj;
		if ([[item objectForKey:@"type"] isEqual:@"submenu"]) {
			[self createCodaMenuItemsFromArray:[item objectForKey:@"items"] forSubmenuWithTitle:[item objectForKey:@"name"] withShortcuts:shortcuts];
		} else {
			NSString *shortcut = @"";
			if (shortcuts && [shortcuts objectForKey:[item objectForKey:@"name"]]) {
				shortcut = [shortcuts objectForKey:[item objectForKey:@"name"]];
			}
			
			[controller registerActionWithTitle:[item objectForKey:@"label"] underSubmenuWithTitle:submenu target:self selector:@selector(performMenuAction:) representedObject:nil keyEquivalent:shortcut pluginName:[self name]];
			
//			if (submenu != nil) {
//				[controller registerActionWithTitle:[item objectForKey:@"label"] underSubmenuWithTitle:submenu target:self selector:@selector(performMenuAction:) representedObject:nil keyEquivalent:shortcut pluginName:[self name]];
//			} else {
//				[controller registerActionWithTitle:[item objectForKey:@"label"] target:self selector:@selector(performMenuAction:)];
//			}
		}
	}];
}

- (void)performMenuAction:(id)sender {
	ZenCoding *zc = [ZenCoding sharedInstance];
	editor.tv = [controller focusedTextView:self];
	[zc performMenuAction:sender];
}

- (void)showPreferences:(id)sender {
	if (prefs == nil) {
		prefs = [[ZCBasicPreferencesWindowController alloc] init];
	}
	
	[prefs showWindow:self];
}

@end
