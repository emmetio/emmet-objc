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
	NSLog(@"Shortcuts: %@", shortcuts);
	NSMenu *menu = [[ZenCoding sharedInstance] actionsMenuWithAction:@selector(performMenuAction:) keyboardShortcuts:shortcuts forTarget:self];
	NSMenuItem *rootItem = [[NSApp mainMenu] addItemWithTitle:@"Emmet" action:nil keyEquivalent:@""];
	rootItem.submenu = menu;
}

- (void)performMenuAction:(id)sender {
	[[ZenCoding sharedInstance] performMenuAction:sender];
}

- (void)dealloc {
	[editor release];
	[super dealloc];
}


@end