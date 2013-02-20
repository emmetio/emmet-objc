//
//  CodaSample.h
//  CodaSample
//
//  Created by Sergey Chikuyonok.
//  Copyright 2012. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "CodaPlugInsController.h"
#import "EMCodaEditor.h"
#import "EMBasicPreferencesWindowController.h"
#import <Sparkle/Sparkle.h>

@class CodaPlugInsController;

@interface EMCodaPlugin : NSObject <CodaPlugIn> {
	CodaPlugInsController* controller;
	EMCodaEditor *editor;
	EMBasicPreferencesWindowController *prefs;
	NSString *keyboardShortcutsPlist;
	SUUpdater *updater;
}

- (void)performMenuAction:(id)sender;
- (void)checkForUpdates:(id)sender;

@end
