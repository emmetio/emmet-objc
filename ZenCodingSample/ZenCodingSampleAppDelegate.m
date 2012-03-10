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

@implementation ZenCodingSampleAppDelegate

@synthesize window;

+ (void)initialize {
	// Load Zen Coding preferences defaults
	[ZenCodingPreferences loadDefaults];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
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
