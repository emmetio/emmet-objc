//
//  ZenCodingSampleAppDelegate.m
//  ZenCodingSample
//
//  Created by Сергей Чикуёнок on 2/18/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import "ZenCodingSampleAppDelegate.h"
#import "ZenCoding.h"
#import "ZenCodingPromptDialogController.h"
#import "ZenCodingPreferences.h"
#import "ZenCodingDefaultsKeys.h"

#define TabKeyCode 48
#define NoFlags (NSShiftKeyMask | NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask)

@implementation ZenCodingSampleAppDelegate

@synthesize window;

+ (void)initialize {
	// Load Zen Coding preferences defaults
	[ZenCodingPreferences loadDefaults];
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
				
				ZenCoding *zc = [ZenCoding sharedInstance];
				[zc setContext:textArea];
				
				// if abbreviation expanded successfully, stop event
				// otherwise, pass it further
				if ([zc runAction:@"expand_abbreviation"]) {
					return (NSEvent *)nil;
				}
			}
		}
		
		return event;
	}];
	
}

- (IBAction)expandAbbreviation:(id)sender {
	ZenCoding *zc = [ZenCoding sharedInstance];
	[zc setContext:textArea];
	[zc runAction:@"expand_abbreviation"];
}

- (IBAction)showPrompt:(id)sender {
	NSLog(@"Entered value: %@", [ZenCodingPromptDialogController prompt:@"Hello world"]);
}

- (IBAction)showPreferences:(id)sender {
	if (prefs == nil) {
		prefs = [[ZenCodingPreferences alloc] init];
	}
	
	[prefs showWindow:self];
}

@end
