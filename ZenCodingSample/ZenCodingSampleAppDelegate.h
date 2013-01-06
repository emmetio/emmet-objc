//
//  ZenCodingSampleAppDelegate.h
//  ZenCodingSample
//
//  Created by Сергей Чикуёнок on 2/18/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MGSFragaria/MGSFragaria.h>
#import "EMBasicPreferencesWindowController.h"
#import "EMFragariaEditor.h"

@interface ZenCodingSampleAppDelegate : NSObject <NSApplicationDelegate> {
	NSWindow *window;
	NSTextView *tv;
	IBOutlet NSView *textArea;
	EMBasicPreferencesWindowController *prefs;
	MGSFragaria *fragaria;
	EMFragariaEditor *editor;
	
	NSArrayController *syntaxesController;
}

@property (assign) IBOutlet NSWindow *window;
- (IBAction)showPreferences:(id)sender;
@property (assign) IBOutlet NSArrayController *syntaxesController;

- (NSString *)syntaxDefinition;
- (void)setSyntaxDefinition:(NSString *)name;

@end
