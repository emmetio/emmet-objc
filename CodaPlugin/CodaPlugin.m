//
//  CodaSample.m
//  CodaSample
//
//  Created by Сергей Чикуёнок on 2/22/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import "CodaPlugin.h"
#import "CodaZenEditor.h"
#import <ZenCoding/ZenCoding.h>

#define TabKeyCode 48
#define NoFlags (NSShiftKeyMask | NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask)

@interface CodaPlugin ()

- (id)initWithController:(CodaPlugInsController*)inController;
- (void)createMenu;
- (void)createCodaMenuItemsFromMenu:(NSMenu *)menu forSubmenuWithTitle:(NSString *)submenu;

@end

@implementation CodaPlugin

- (NSString*)name {
	return @"Zen Coding";
}

//2.0 and lower
- (id)initWithPlugInController:(CodaPlugInsController*)aController bundle:(NSBundle*)aBundle {
    return [self initWithController:aController];
}


//2.0.1 and higher
- (id)initWithPlugInController:(CodaPlugInsController*)aController plugInBundle:(NSObject <CodaPlugInBundle> *)plugInBundle {
    return [self initWithController:aController];
}

- (id)initWithController:(CodaPlugInsController *)aController {
	if ((self = [super init]) != nil) {
		controller = aController;
		[ZenCodingPreferences loadDefaults];
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
	NSMenu *menu = [[ZenCoding sharedInstance] actionsMenu];
	[self createCodaMenuItemsFromMenu:menu forSubmenuWithTitle:nil];
	[controller registerActionWithTitle:@"Preferences..." target:self selector:@selector(showPreferences:)];
}

- (void)createCodaMenuItemsFromMenu:(NSMenu *)menu forSubmenuWithTitle:(NSString *)submenu {
	[[menu itemArray] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSMenuItem *item = (NSMenuItem *)obj;
		if ([item submenu]) {
			[self createCodaMenuItemsFromMenu:[item submenu] forSubmenuWithTitle:[item title]];
		} else {
			if (submenu != nil) {
				[controller registerActionWithTitle:[item title] underSubmenuWithTitle:submenu target:self selector:@selector(performMenuAction:) representedObject:nil keyEquivalent:@"" pluginName:[self name]];
			} else {
				[controller registerActionWithTitle:[item title] target:self selector:@selector(performMenuAction:)];
			}
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
		prefs = [[ZenCodingPreferences alloc] init];
	}
	
	[prefs showWindow:self];
}

@end
