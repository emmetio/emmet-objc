//
//  ZenCodingSampleAppDelegate.h
//  ZenCodingSample
//
//  Created by Сергей Чикуёнок on 2/18/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZenCodingPreferences.h"

@interface ZenCodingSampleAppDelegate : NSObject <NSApplicationDelegate> {
	NSWindow *window;
	IBOutlet NSTextView *textArea;
	ZenCodingPreferences *prefs;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)expandAbbreviation:(id)sender;
- (IBAction)showPrompt:(id)sender;
- (IBAction)showPreferences:(id)sender;

@end
