//
//  ZenCodingSampleAppDelegate.h
//  ZenCodingSample
//
//  Created by Сергей Чикуёнок on 2/18/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EMBasicPreferencesWindowController.h"

@interface ZenCodingSampleAppDelegate : NSObject <NSApplicationDelegate> {
	NSWindow *window;
	NSTextView *tv;
	IBOutlet NSTextView *textArea;
	EMBasicPreferencesWindowController *prefs;
}

@property (assign) IBOutlet NSWindow *window;
- (IBAction)showPreferences:(id)sender;

@end
