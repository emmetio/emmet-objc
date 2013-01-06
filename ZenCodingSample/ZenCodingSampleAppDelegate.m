//
//  ZenCodingSampleAppDelegate.m
//  ZenCodingSample
//
//  Created by Сергей Чикуёнок on 2/18/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import "ZenCodingSampleAppDelegate.h"
#import "Emmet.h"
#import "EMPromptDialogController.h"
#import "JSCocoaDelegate.h"

#define TabKeyCode 48
#define NoFlags (NSShiftKeyMask | NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask)

@implementation ZenCodingSampleAppDelegate
@synthesize syntaxesController;

@synthesize window;

+ (void)initialize {
	[Emmet setJSContextDelegateClass:[JSCocoaDelegate class]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	syntaxesController.content = [NSMutableArray arrayWithObjects:@"HTML", @"XML", @"CSS", nil];
	[syntaxesController addObserver:self forKeyPath:@"selectionIndex" options:0 context:nil];
	
	// init Fragaria component
	fragaria = [[MGSFragaria alloc] init];
	[self setSyntaxDefinition:@"HTML"];
	[fragaria embedInView:textArea];
	
	editor = [[EMFragariaEditor alloc] initWithBackend:fragaria];
	tv = [fragaria objectForKey:ro_MGSFOTextView];
	
	// Implementing abbreviation expand by Tab key
	// This logic should be implemented for each editor independently,
	// because it should also check if current editor state allow Tab key
	// interception (e.g. if it contains tabstops)
	[NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *event) {
		// handle event only for key text view
		if ([window isKeyWindow] && [window firstResponder] == tv) {
			if ([event keyCode] == TabKeyCode && ([event modifierFlags] & NoFlags) == 0 && [[NSUserDefaults standardUserDefaults] boolForKey:ExpandWithTabKey]) {
				
				// if abbreviation expanded successfully, stop event.
				// otherwise, pass it further
				if ([self runAction:@"expand_abbreviation_with_tab"]) {
					return (NSEvent *)nil;
				}
			}
		}
		
		return event;
	}];
	
	// add actions as global menu item
	
	NSString *keyboardShortcutsPlist = [[NSBundle mainBundle] pathForResource:@"KeyboardShortcuts" ofType:@"plist"];
	NSDictionary *shortcuts = [NSDictionary dictionaryWithContentsOfFile:keyboardShortcutsPlist];
	
	NSMenu *mainMenu = [NSApp mainMenu];
	NSMenu *actionsMenu = [[Emmet sharedInstance] actionsMenuWithAction:@selector(performMenuAction:) keyboardShortcuts:shortcuts forTarget:self];
	NSMenuItem *actionsItem = [[NSMenuItem alloc] initWithTitle:[actionsMenu title] action:NULL keyEquivalent:@""];
	[actionsItem setSubmenu:actionsMenu];
	[mainMenu insertItem:actionsItem atIndex:4];
	
	[actionsItem release];
	
	[window makeFirstResponder:tv];
}

- (void)performMenuAction:(id)sender {
	Emmet *em = [Emmet sharedInstance];
	[self runAction:[em resolveActionNameFromMenu:sender]];
}

- (BOOL)runAction:(NSString *)name {
	Emmet *em = [Emmet sharedInstance];
	[em setContext:editor];
	NSUndoManager *undo = [tv undoManager];
//	[undo beginUndoGrouping];
	BOOL result = [em runAction:name];
//	[undo endUndoGrouping];
	[undo setActionName:name];
	return result;
}

- (IBAction)showPreferences:(id)sender {
	if (prefs == nil) {
		prefs = [[EMBasicPreferencesWindowController alloc] init];
	}
	
	[prefs showWindow:self];
}

- (NSString *)syntaxDefinition {
	return [fragaria objectForKey:MGSFOSyntaxDefinitionName];
	
}

- (void)setSyntaxDefinition:(NSString *)name {
	[fragaria setObject:name forKey:MGSFOSyntaxDefinitionName];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context {
	
	if ([keyPath isEqual:@"selectionIndex"]) {
		NSUInteger ix = syntaxesController.selectionIndex;
		NSString *syntax = [syntaxesController.content objectAtIndex:ix];
		[self setSyntaxDefinition:syntax];
	}
}

@end
