//
//  ZenCodingPreferences.m
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 3/9/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "ZenCodingPreferences.h"
#import "ZenCodingArrayTransformer.h"
#import "ZenCodingTildePathTransformer.h"

@implementation ZenCodingPreferences
@synthesize syntaxList;
@synthesize extensionsPathField;
@synthesize outputPrefs, outputPrefsDict;

- (id)init {
    return [super initWithWindowNibName:@"Preferences"];
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
		NSLog(@"Output: %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"outputPreferences"]);
		
		ZenCodingArrayTransformer *caseTransformer = [[[ZenCodingArrayTransformer alloc] initWithArray:[NSArray arrayWithObjects:@"lower", @"upper", @"asis", nil]] autorelease];
		
		ZenCodingArrayTransformer *quotesTransformer = [[[ZenCodingArrayTransformer alloc] initWithArray:[NSArray arrayWithObjects:@"single", @"double", nil]] autorelease];
		
		ZenCodingArrayTransformer *selfClosingTransformer = [[[ZenCodingArrayTransformer alloc] initWithArray:[NSArray arrayWithObjects:@"html", @"xml", @"xhtml", nil]] autorelease];
		ZenCodingTildePathTransformer *pathTransformer = [[ZenCodingTildePathTransformer new] autorelease];
		
		
		[NSValueTransformer setValueTransformer:caseTransformer forName:@"ZenCodingCaseTransformer"];
		[NSValueTransformer setValueTransformer:quotesTransformer forName:@"ZenCodingQuotesTransformer"];
		[NSValueTransformer setValueTransformer:selfClosingTransformer forName:@"ZenCodingSelfClosingTransformer"];
		[NSValueTransformer setValueTransformer:pathTransformer forName:@"ZenCodingTildePathTransformer"];
    }
    
    return self;
}

- (void)windowDidLoad
{
	NSWindow *window = [self window];
    [window setHidesOnDeactivate:NO];
    [window setExcludedFromWindowsMenu:YES];
    [window setIdentifier:@"ZenCodingPreferences"];
	[super windowDidLoad];
}

- (BOOL)windowShouldClose:(NSWindow *)window {
    return [window makeFirstResponder:nil]; // validate editing
}

- (IBAction)pickExtensionsFolder:(id)sender {
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	[panel setCanChooseFiles:NO];
	[panel setCanChooseDirectories:YES];
	[panel setAllowsMultipleSelection:NO];

	[panel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
	    if (result == NSOKButton) {
			NSURL *url = [[panel URLs] objectAtIndex:0];
			if (url != nil) {
				NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
				[defaults setValue:[url path] forKey:@"extensionsPath"];
			}
			
	    }
	}];
	
}
+ (void)loadDefaults {
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PreferencesDefaults" ofType:@"plist"];
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:prefs];
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:prefs];
	[prefs release];
}

@end
