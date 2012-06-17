//
//  CodaSample.h
//  CodaSample
//
//  Created by Sergey Chikuyonok.
//  Copyright 2012. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "CodaPlugInsController.h"
#import "CodaZenEditor.h"
#import "ZenCodingPreferences.h"

@class CodaPlugInsController;
@interface CodaPlugin : NSObject <CodaPlugIn> {
	CodaPlugInsController* controller;
	CodaZenEditor *editor;
	ZenCodingPreferences *prefs;
}

- (void)performMenuAction:(id)sender;

@end
