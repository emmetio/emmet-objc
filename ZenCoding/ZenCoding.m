//
//  ZenCoding.m
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 2/9/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import "ZenCoding.h"
#import "ZenCodingDefaultsKeys.h"
#import "ZenCodingNotifications.h"
#import "NSMutableDictionary+ZCUtils.h"
#import "JSONKit.h"

@interface ZenCoding ()
- (void)setupJSContext;
- (void)loadUserData;
- (NSDictionary *)settingsFromDefaults;
- (void)shouldReloadContext:(NSNotification *)notification;
- (NSDictionary *)createOutputProfileFromDict:(NSDictionary *)dict;
- (void)createMenuItemsFromArray:(NSArray *)dict forMenu:(NSMenu *)menu withAction:(SEL)action ofTarget:(id)target;
@end

@implementation ZenCoding

@synthesize context, jsc, extensionsPath;

static ZenCoding *instance = nil;

+(ZenCoding *) sharedInstance {
	@synchronized(self) {
		if (instance == nil) {
			instance = [[ZenCoding alloc] init];
		}
		return instance;
	}
}

- (id)init {
    if (self = [super init]) {
        [self setupJSContext];
		// subscribe for user preferences change notifications:
		// we have to re-create JS context in order to load the latest
		// user preferences.
		// Right now, the only easy way to understand if anything is changed
		// is to listen to "close" event of preferences window
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(shouldReloadContext:) 
													 name:PreferencesWindowClosed 
												   object:nil];
		
    }
    
    return self;
}

- (id)initWithExtensionsPath:(NSString *)path {
	if (self = [super init]) {
		self.extensionsPath = path;
	}
	
	return self;
}

- (void)setupJSContext {
	if (self->jsc != nil) {
		[self->jsc release];
	}
	
	self->jsc = [JSCocoa new];
	
	jsc.useAutoCall = NO;
	jsc.useJSLint = NO;
	
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	[jsc evalJSFile:[bundle pathForResource:@"zencoding" ofType:@"js"]];
	[jsc evalJSFile:[bundle pathForResource:@"objc-zeneditor-wrap" ofType:@"js"]];
	
	// load system snippets
	NSString *snippetsJSON = [NSString 
						  stringWithContentsOfFile:[bundle pathForResource:@"snippets" ofType:@"json"] 
						  encoding:NSUTF8StringEncoding 
						  error:nil];
	
	[self evalFunction:@"objcLoadSystemSnippets" withArguments:snippetsJSON, nil];
	
	// load Zen Coding extensions
	if (extensionsPath) {
		NSString *extPath = extensionsPath;
		BOOL isDir;
		NSFileManager *fm = [NSFileManager defaultManager];
		if ([fm fileExistsAtPath:extPath isDirectory:&isDir] && isDir) {
			NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:extPath];
			
			// find all JS files and eval them
			NSString *file;
			while (file = [dirEnum nextObject]) {
				if ([[[file pathExtension] lowercaseString] isEqualToString: @"js"]) {
					[jsc evalJSFile:[extPath stringByAppendingPathComponent:file]];
				}
			}
		}
	}
	
	// load user preferences
	[self loadUserData];
}

- (void)setContext:(id)ctx {
	if (self->context != ctx) {
		if (self->context)
			[self->context release];
		
		self->context = nil;
		if (ctx) {
			self->context = [ctx retain];
			[self evalFunction:@"objcSetContext" withArguments:ctx, nil];
		}
	}
}

- (NSString *)extensionsPath {
	NSString *path = self->extensionsPath;
	if (path == nil || [path isEqual:@""]) {
		path = [[NSUserDefaults standardUserDefaults] stringForKey:ExtensionsPath];
	}
	
	if (path != nil && ![path isEqual:@""]) {
		path = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if ([path hasPrefix:@"~"]) {
			path = [path stringByExpandingTildeInPath];
		}
		
		return path;
	}
	
	return nil;
}

- (void)setExtensionsPath:(NSString *)path {
	if (![extensionsPath isEqual:path]) {
		if (self->extensionsPath != nil) {
			[self->extensionsPath release];
		}
		
		self->extensionsPath = [path retain];
		
		[self setupJSContext];
	}
}

- (BOOL)runAction:(id)name {
	return [jsc toBool:[self evalFunction:@"objcRunAction" withArguments:name, nil]];
}

- (JSValueRef)evalFunction:(NSString *)funcName withArguments:(id)firstArg, ... {
	// Convert args to array
	id arg;
	NSMutableArray *arguments = [NSMutableArray array];
	NSMutableArray *argNames = [NSMutableArray array];
	
	if (firstArg) {
		[arguments addObject:firstArg];
		
		va_list	args;
		va_start(args, firstArg);
		while ((arg = va_arg(args, id)))	
			[arguments addObject:arg];
		va_end(args);
	}
	
	// register all arguments in JS context
	for (NSUInteger i = 0; i < [arguments count]; i++) {
		[argNames addObject:[NSString stringWithFormat:@"__objcArg%d", i]];
		[jsc setObject:[arguments objectAtIndex:i] withName:[argNames lastObject]];
	}
	
	// create JS string to evaluate
	NSString *jsString = [NSString stringWithFormat:@"%@(%@)", funcName, [argNames componentsJoinedByString:@", "]];
	
//	NSLog(@"Eval JS: %@", jsString);
	JSValueRef result = [jsc evalJSString:jsString];
	
	// unregister all arguments from JS context
	for (NSString *argName in argNames) {
		[jsc removeObjectWithName:argName];
	}
	
	return result;
}

- (NSString *)readUserJSON:(NSString *)fileName {
	// check if json exists in extensions path
	if (extensionsPath) {
		NSString *outputFile = [extensionsPath stringByAppendingPathComponent:fileName];
		if ([[NSFileManager defaultManager] isReadableFileAtPath:outputFile]) {
			return [NSString stringWithContentsOfFile:outputFile encoding:NSUTF8StringEncoding error:nil];
		}
	}
	
	// file not fount or unavailable
	return nil;
}

- (void)loadUserData {
	NSString *settingsContents = [self readUserJSON:@"snippets.json"];
	if (settingsContents == nil) {
		settingsContents = @"{}";
	}
	
	// pass data as JSON strings for safer internal types conversion
	[self evalFunction:@"objcLoadUserSnippets" withArguments:settingsContents, [[self settingsFromDefaults] JSONString], nil];
	
	NSString *preferencesContents = [self readUserJSON:@"preferences.json"];
	if (preferencesContents) {
		[self evalFunction:@"objcLoadUserPreferences" withArguments:preferencesContents, nil];
	}
}

- (NSDictionary *)settingsFromDefaults {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary *result = [NSMutableDictionary new];
	NSMutableDictionary *ctx;
	
	// read variables
	NSArray *defaultsCtx = [defaults arrayForKey:Variables];
	if (defaultsCtx) {
		ctx = [NSMutableDictionary new];
		for (NSDictionary *item in defaultsCtx) {
			[ctx setObject:[item objectForKey:@"value"] forKey:[item objectForKey:@"name"]];
		}
		
		[result setObject:ctx forKey:@"variables"];
		[ctx release];
		defaultsCtx = nil;
	}
	
	// Read abbreviations and snippets. Since they share the same syntax
	// context, we need to create single context for both of them
	ctx = [NSMutableDictionary new];
	NSMutableDictionary *syntaxCtx;
	NSString *syntax;
	
	defaultsCtx = [defaults arrayForKey:Abbreviations];
	if (defaultsCtx) {
		for (NSDictionary *item in defaultsCtx) {
			syntax = [item objectForKey:@"syntax"];			
			syntaxCtx = [[ctx dictionaryForKey:syntax] dictionaryForKey:@"abbreviations"];
			[syntaxCtx setObject:[item objectForKey:@"value"] forKey:[item objectForKey:@"name"]];
		}
	}
	
	defaultsCtx = [defaults arrayForKey:Snippets];
	if (defaultsCtx) {
		for (NSDictionary *item in defaultsCtx) {
			syntax = [item objectForKey:@"syntax"];			
			syntaxCtx = [[ctx dictionaryForKey:syntax] dictionaryForKey:@"snippets"];
			[syntaxCtx setObject:[item objectForKey:@"value"] forKey:[item objectForKey:@"name"]];
		}
	}
	
	// add output profiles
	NSDictionary *output = [defaults dictionaryForKey:Output];
	if (output) {
		[output enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
			[[ctx dictionaryForKey:key] setObject:[self createOutputProfileFromDict:obj] forKey:@"profile"];
		}];
	}
	
	[result addEntriesFromDictionary:ctx];
	[ctx release];
	
	return [result autorelease];
}

- (void)shouldReloadContext:(NSNotification *)notification {
	// remember previously saved context
	id ctx = self.context;
	self.context = nil;
	[self setupJSContext];
	self.context = ctx;
}

- (NSDictionary *)createOutputProfileFromDict:(NSDictionary *)dict {
	NSDictionary *keysMap = [NSDictionary dictionaryWithObjectsAndKeys:
							 @"tag_case", @"tagCase",
							 @"attr_case", @"attributeCase",
							 @"attr_quotes", @"attributeQuote",
							 @"indent", @"indent",
							 @"tag_nl", @"tagNewline",
							 @"inline_break", @"inlineBreaks",
							 @"filters", @"filters",
							 nil];
	
	
	
	NSMutableDictionary *result = [NSMutableDictionary dictionary];
	
	[keysMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		if ([dict objectForKey:key]) {
			[result setObject:[dict objectForKey:key] forKey:obj];
		}
	}];
	
	if ([[dict objectForKey:@"selfClosing"] isEqual:@"html"]) {
		[result setObject:[NSNumber numberWithBool:NO] forKey:@"self_closing_tag"];
	} else if ([[dict objectForKey:@"selfClosing"] isEqual:@"xml"]) {
		[result setObject:[NSNumber numberWithBool:YES] forKey:@"self_closing_tag"];
	} else {
		[result setObject:@"xhtml" forKey:@"self_closing_tag"];
	}
	
	return result;
}

- (NSArray *)actionsList {
	return [jsc toObject:[self evalFunction:@"zen_coding.require('actions').getMenu" withArguments:nil]];
}

// returns Zen Coding actions as menu
- (NSMenu *)actionsMenu {
	return [self actionsMenuWithAction:@selector(performMenuAction:) forTarget:self];
}

- (NSMenu *)actionsMenuWithAction:(SEL)action forTarget:(id)target {
	NSMenu *rootMenu = [[NSMenu alloc] initWithTitle:@"Zen Coding"];
	[self createMenuItemsFromArray:[self actionsList] forMenu:rootMenu withAction:action ofTarget:target];
	return [rootMenu autorelease];
}

- (void)createMenuItemsFromArray:(NSArray *)items forMenu:(NSMenu *)menu withAction:(SEL)action ofTarget:(id)target {
	[items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSDictionary *objDict = (NSDictionary *)obj;
		if ([[objDict objectForKey:@"type"] isEqual:@"submenu"]) {
			// create submenu
			NSString *submenuName = [objDict valueForKey:@"name"];
			NSMenu *submenu = [[NSMenu alloc] initWithTitle:submenuName];
			[self createMenuItemsFromArray:[objDict objectForKey:@"items"] forMenu:submenu withAction:action ofTarget:target];
			
			NSMenuItem *submenuItem = [[NSMenuItem alloc] initWithTitle:submenuName action:NULL keyEquivalent:@""];
			[menu addItem:submenuItem];
			[submenuItem setSubmenu:submenu];
			
			[submenu release];
			[submenuItem release];
		} else {
			NSMenuItem *actionItem = [[NSMenuItem alloc] initWithTitle:[objDict valueForKey:@"label"] action:action keyEquivalent:@""];
			[actionItem setTarget:target];
			[menu addItem:actionItem];
			[actionItem release];
		}
	}];
}

- (void)performMenuAction:(id)sender {
	if ([sender isKindOfClass:[NSMenuItem class]]) {
		NSString *title = [(NSMenuItem *)sender title];
		id actionName = [jsc unboxJSValueRef:[self evalFunction:@"zen_coding.require('actions').getActionNameForMenuTitle" withArguments:title, nil]];
		
		if (actionName != nil) {
			[self runAction:actionName];
		}
	}
}

- (void)dealloc {
	if (self->extensionsPath) {
		[self->extensionsPath release];
	}
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

@end
