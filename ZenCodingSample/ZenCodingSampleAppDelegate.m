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

@implementation ZenCodingSampleAppDelegate

@synthesize window;

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
@end
