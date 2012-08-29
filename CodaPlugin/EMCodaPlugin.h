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
#import "ZCBasicPreferencesWindowController.h"

@class CodaPlugInsController;

@interface EMCodaPlugin : NSObject <CodaPlugIn> {
	CodaPlugInsController* controller;
	EMCodaEditor *editor;
	ZCBasicPreferencesWindowController *prefs;
	NSString *keyboardShortcutsPlist;
}

- (void)performMenuAction:(id)sender;

@end
