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
#import "ZenCodingSnippetEditor.h"

@interface ZenCodingPreferences ()
- (void)updateOutputPrefsContext;
@end

@implementation ZenCodingPreferences
@synthesize outputContext;
@synthesize syntaxList;
@synthesize extensionsPathField;
@synthesize snippets;
@synthesize snippetsView;
@synthesize syntaxPopup;

+ (void)initialize {
	ZenCodingArrayTransformer *caseTransformer = [[[ZenCodingArrayTransformer alloc] initWithArray:[NSArray arrayWithObjects:@"lower", @"upper", @"asis", nil]] autorelease];
	
	ZenCodingArrayTransformer *quotesTransformer = [[[ZenCodingArrayTransformer alloc] initWithArray:[NSArray arrayWithObjects:@"single", @"double", nil]] autorelease];
	
	ZenCodingArrayTransformer *selfClosingTransformer = [[[ZenCodingArrayTransformer alloc] initWithArray:[NSArray arrayWithObjects:@"html", @"xml", @"xhtml", nil]] autorelease];
	ZenCodingTildePathTransformer *pathTransformer = [[ZenCodingTildePathTransformer new] autorelease];
	
	
	[NSValueTransformer setValueTransformer:caseTransformer forName:@"ZenCodingCaseTransformer"];
	[NSValueTransformer setValueTransformer:quotesTransformer forName:@"ZenCodingQuotesTransformer"];
	[NSValueTransformer setValueTransformer:selfClosingTransformer forName:@"ZenCodingSelfClosingTransformer"];
	[NSValueTransformer setValueTransformer:pathTransformer forName:@"ZenCodingTildePathTransformer"];
}

- (id)init {
    return [super initWithWindowNibName:@"Preferences"];
}

- (void)awakeFromNib {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *output = [defaults dictionaryForKey:@"output"];
	
	if (output) {
		outputPreferences = [output mutableCopy];
	} else {
		outputPreferences = [NSMutableDictionary new];
	}
}

- (void)windowDidLoad
{
	NSWindow *window = [self window];
    [window setHidesOnDeactivate:NO];
    [window setExcludedFromWindowsMenu:YES];
	
	[snippetsView setTarget:self];
	[snippetsView setDoubleAction:@selector(editSnippet:)];
	
	[syntaxList addObserver:self 
				  forKeyPath:@"selectionIndexes" 
					 options:NSKeyValueObservingOptionNew 
					 context:NULL];
	
	[self updateOutputPrefsContext];
	
	[super windowDidLoad];
}

- (BOOL)windowShouldClose:(NSWindow *)window {
	// save output preferences
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:outputPreferences forKey:@"output"];
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
	//// reset defaults
//	NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
//	for (NSString *key in [defaultsDictionary allKeys]) {
//		[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
//	}
//	[[NSUserDefaults standardUserDefaults] synchronize];
	//// /reset defaults
	
	
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PreferencesDefaults2" ofType:@"plist"];
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:prefs];
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:prefs];
	[prefs release];
}

- (IBAction)addSnippet:(id)sender {
	ZenCodingSnippetEditor *editor = [ZenCodingSnippetEditor new];
	NSDictionary *snippet = [editor openAddDialogForWindow:[self window]];
	if (snippet) {
		NSLog(@"Add snippet: %@", snippet);
		[snippets addObject:snippet];
		[snippet release];
	}
	[editor release];
}

- (IBAction)removeSnippet:(id)sender {
	NSArray *selectedSnippets = [snippets selectedObjects];
	if ([selectedSnippets count]) {
		[snippets removeObjects:selectedSnippets];
	}
}

- (void)editSnippet:(id)sender {
	ZenCodingSnippetEditor *editor = [ZenCodingSnippetEditor new];
	NSDictionary *snippet = [[snippets selectedObjects] objectAtIndex:0];
	
	if (snippet) {
		NSDictionary *editedSnippet = [editor openEditDialog:snippet forWindow:[self window]];
		if (editedSnippet) {
			[editedSnippet enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop){
				[snippet setValue:value forKey:key];
			}];
			
			[editedSnippet release];
		}
	}
	
	[editor release];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"selectionIndexes"] && object == syntaxList) {
		[self updateOutputPrefsContext];
	}
}

- (void)updateOutputPrefsContext {
	NSArray *syntaxArr = [syntaxList selectedObjects];
	if (syntaxArr && [syntaxArr count]) {
		NSDictionary *syntax = [[syntaxList selectedObjects] objectAtIndex:0];
		NSString *syntaxId = [syntax valueForKey:@"id"];
		[outputContext setContent:[outputPreferences objectForKey:syntaxId]];
	}
}

- (void)dealloc {
	[outputPreferences release];
	[super dealloc];
}

@end
