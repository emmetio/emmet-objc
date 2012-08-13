//
//  ZCTextmatePlugin.m
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 8/11/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "ZCTextmatePlugin.h"
#import "JSCocoaDelegate.h"
#import "TextMateZenEditor.h"

static NSString * const ZenCodingBundleIdentifier = @"ru.chikuyonok.ZenCodingTextmate";

@interface ZCTextmatePlugin ()
- (void)performMenuAction:(id)sender;
@end

@implementation ZCTextmatePlugin

+ (NSBundle *)bundle {
	return [NSBundle bundleWithIdentifier:ZenCodingBundleIdentifier];
}

- (id)initWithPlugInController:(id <TMPlugInController>)aController {
	self = [super init];
	if (self != nil) {
		NSApp = [NSApplication sharedApplication];
		NSBundle *bundle = [ZCTextmatePlugin bundle];
		
		[ZenCoding addCoreFile:[bundle pathForResource:@"textmate-bootstrap" ofType:@"js"]];
		[ZenCoding setJSContextDelegateClass:[JSCocoaDelegate class]];
		
		editor = [TextMateZenEditor new];
		[[ZenCoding sharedInstance] setContext:editor];
		
		[self installMenuItems];
	}
	return self;
}

- (void)installMenuItems {
	NSString *keyboardShortcutsPlist = [[ZCTextmatePlugin bundle] pathForResource:@"KeyboardShortcuts" ofType:@"plist"];
	NSDictionary *shortcuts = [NSDictionary dictionaryWithContentsOfFile:keyboardShortcutsPlist];
	NSLog(@"Shortcuts: %@", shortcuts);
	NSMenu *menu = [[ZenCoding sharedInstance] actionsMenuWithAction:@selector(performMenuAction:) keyboardShortcuts:shortcuts forTarget:self];
	NSMenuItem *rootItem = [[NSApp mainMenu] addItemWithTitle:@"Zen Coding" action:nil keyEquivalent:@""];
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