//
//  ZCBasicPreferencesWindowController.m
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 8/3/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "ZCBasicPreferencesWindowController.h"
#import "ZenCoding.h"
#import "ZenCodingArrayTransformer.h"
#import "ZenCodingTildePathTransformer.h"

@interface ZCBasicPreferencesWindowController ()
+ (NSArray *)loadOutputPreferences;
+ (void)storeOutputPreferences:(NSArray *)prefs;
@end

@implementation ZCBasicPreferencesWindowController
@synthesize outputProfiles;

+ (void)initialize {
	ZenCodingArrayTransformer *caseTransformer = [[[ZenCodingArrayTransformer alloc] initWithArray:[NSArray arrayWithObjects:@"lower", @"upper", @"asis", nil]] autorelease];
	
	ZenCodingArrayTransformer *quotesTransformer = [[[ZenCodingArrayTransformer alloc] initWithArray:[NSArray arrayWithObjects:@"single", @"double", nil]] autorelease];
	
	ZenCodingArrayTransformer *tagNlTransformer = [[[ZenCodingArrayTransformer alloc] initWithArray:[NSArray arrayWithObjects:@"yes", @"no", @"decide", nil]] autorelease];
	
	ZenCodingArrayTransformer *selfClosingTransformer = [[[ZenCodingArrayTransformer alloc] initWithArray:[NSArray arrayWithObjects:@"html", @"xml", @"xhtml", nil]] autorelease];
	ZenCodingTildePathTransformer *pathTransformer = [[ZenCodingTildePathTransformer new] autorelease];
	
	
	[NSValueTransformer setValueTransformer:caseTransformer forName:@"ZenCodingCaseTransformer"];
	[NSValueTransformer setValueTransformer:quotesTransformer forName:@"ZenCodingQuotesTransformer"];
	[NSValueTransformer setValueTransformer:selfClosingTransformer forName:@"ZenCodingSelfClosingTransformer"];
	[NSValueTransformer setValueTransformer:pathTransformer forName:@"ZenCodingTildePathTransformer"];
	[NSValueTransformer setValueTransformer:tagNlTransformer forName:@"ZenCodingTagNewlineTransformer"];
}

+ (void)resetDefaults {
	NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
	for (NSString *key in [defaultsDictionary allKeys]) {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)loadOutputPreferences {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *output = [defaults dictionaryForKey:Output];
	NSArray *syntax = [defaults arrayForKey:@"syntax"];
	
	NSMutableArray *outputProfiles = [NSMutableArray array];
	
	// add output profile to syntax list
	[syntax enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
		NSMutableDictionary *profileObj = [obj mutableCopy];
		NSString *syntaxId = [obj objectForKey:@"id"];
		if (syntaxId != nil && [output objectForKey:syntaxId] != nil) {
			[profileObj setObject:[[output objectForKey:syntaxId] mutableCopy] forKey:@"profile"];
		}
		
		[outputProfiles addObject:profileObj];
	}];
	
	return outputProfiles;
}

+ (void)storeOutputPreferences:(NSArray *)prefs {
	NSMutableDictionary *profiles = [NSMutableDictionary dictionary];
	[prefs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[profiles setObject:[obj objectForKey:@"profile"] forKey:[obj objectForKey:@"id"]];
	}];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:profiles forKey:Output];
}

- (id)init {
    return [super initWithWindowNibName:@"BasicPreferences"];
}

- (void)awakeFromNib {
	[ZenCoding loadDefaults];
	outputProfiles.content = [ZCBasicPreferencesWindowController loadOutputPreferences];
}

- (void)windowDidLoad {
	NSWindow *window = [self window];
    [window setHidesOnDeactivate:NO];
    [window setExcludedFromWindowsMenu:YES];	
	[super windowDidLoad];
}

- (BOOL)windowShouldClose:(NSWindow *)window {
	// save output preferences
	[ZCBasicPreferencesWindowController storeOutputPreferences:outputProfiles.content];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults synchronize];
	
	[[ZenCoding sharedInstance] reload];
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
				[defaults setValue:[url path] forKey:ExtensionsPath];
			}
	    }
	}];
}

- (void)dealloc {
	[super dealloc];
}

@end
