//
//  Created by Сергей Чикуёнок on 2/9/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import "Emmet.h"
#import "EMUserDataLoader.h"
#import "NSMutableDictionary+EMUtils.h"

void setKeyEquivalent(NSMenuItem *menuItem, NSString *key) {
	if (!key || [key isEqualToString:@""]) {
		return;
	}
	
	NSString *k = nil;
	NSUInteger modifiers = 0;
	
	for (int i = 0; i < [key length]; i++) {
		switch ([key characterAtIndex:i]) {
			case '$': modifiers |= NSShiftKeyMask;      break;
			case '^': modifiers |= NSControlKeyMask;    break;
			case '~': modifiers |= NSAlternateKeyMask;  break;
			case '@': modifiers |= NSCommandKeyMask;    break;
			case '#': modifiers |= NSNumericPadKeyMask; break;
			default: k = [key substringWithRange:NSMakeRange(i, 1)];
		}
	}
	
	if (k && menuItem) {
		[menuItem setKeyEquivalent:k];
		[menuItem setKeyEquivalentModifierMask:modifiers];
	}
	
}

@interface Emmet ()
- (void)setupJSContext;
- (void)loadUserData;
- (void)loadExtensions;
- (void)createMenuItemsFromArray:(NSArray *)dict forMenu:(NSMenu *)menu withAction:(SEL)action keyboardShortcuts:(NSDictionary *)shortcuts ofTarget:(id)target;
@end

@implementation Emmet

@synthesize context, jsc, extensionsPath;

static Emmet *instance = nil;
static Class jsCtxDelegateClass = nil;
static bool defaultsLoaded = false;
static NSMutableArray *coreFiles = nil;

+ (void)initialize {
	coreFiles = [NSMutableArray new];
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSArray *files = [NSArray arrayWithObjects:@"emmet-app", @"file-interface", @"objc-zeneditor-wrap", nil];
	[files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[Emmet addCoreFile:[bundle pathForResource:obj ofType:@"js"]];
	}];
}

+ (void)setJSContextDelegateClass:(Class)cl {
	jsCtxDelegateClass = cl;
}

+ (Emmet *)sharedInstance {
	@synchronized(self) {
		if (instance == nil) {
			instance = [Emmet new];
		}
		return instance;
	}
}

+ (void)addCoreFile:(NSString *)file {
	[coreFiles addObject:file];
}

+ (void)loadDefaults {
	if (defaultsLoaded)
		return;
	
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *plistPath = [bundle pathForResource:@"PreferencesDefaults" ofType:@"plist"];
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:prefs];
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:prefs];
	[prefs release];
	
	defaultsLoaded = true;
}
+ (NSString *)toJSON:(id)obj {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:&error];
    if (error) {
        NSLog(@"Serialize object to JSON error: %@", error);
        return @"{}";
    }
    return [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
}

- (id)init {
    if (self = [super init]) {
		[Emmet loadDefaults];
        [self setupJSContext];
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
	
	if (jsCtxDelegateClass != nil) {
		self->jsc = [jsCtxDelegateClass new];
	} else {
		// get JS delegate class name from bundle Info.plist
		NSString *jscClassName = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"EMJavascriptDelegate"];
		
		self->jsc = [NSClassFromString(jscClassName) new];
	}
	
	// load core files
	[coreFiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[jsc evalFile:obj];
	}];
	[jsc evalFunction:@"emmet_file_setContext" withArguments:[EmmetFile class], nil];
	
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	// load system snippets
	NSString *snippetsJSON = [NSString 
						  stringWithContentsOfFile:[bundle pathForResource:@"snippets" ofType:@"json"] 
						  encoding:NSUTF8StringEncoding 
						  error:nil];
	
	[jsc evalFunction:@"objcLoadSystemSnippets" withArguments:snippetsJSON, nil];
	
	[self loadExtensions];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:JSContextLoaded object:self];
}

- (void)loadExtensions {
	// load Emmet extensions: create list of files in extensions folder
	// and pass it to bootstrap
	NSString* extPath = extensionsPath;
	if (!extPath) {
		extPath = [EMUserDataLoader extensionsPath];
	}
	if (extPath) {
		BOOL isDir;
		NSFileManager *fm = [NSFileManager defaultManager];
		
		if ([fm fileExistsAtPath:extPath isDirectory:&isDir] && isDir) {
			NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:extPath];
			NSMutableArray *fileList = [NSMutableArray new];
			
			// find all files in extensions folder
			NSString *file;
			while (file = [dirEnum nextObject]) {
				[fileList addObject:[extPath stringByAppendingPathComponent:file]];
			}
			
			if ([fileList count]) {
				[jsc evalFunction:@"objcLoadExtensions" withArguments:[Emmet toJSON:fileList], nil];
			}
			
			[fileList release];
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
			[jsc evalFunction:@"objcSetContext" withArguments:ctx, nil];
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
		
		[self reload];
	}
}

- (BOOL)runAction:(id)name {
	id result = [jsc evalFunction:@"objcRunAction" withArguments:name, nil];
	return (BOOL)[jsc convertJSObject:result toNativeType:@"bool"];
}

- (void)loadUserData {
	NSDictionary *userData = [EMUserDataLoader userData];
//	NSLog(@"Loading user data:\n%@", [Emmet toJSON:userData]);
	[jsc evalFunction:@"objcLoadUserData" withArguments:[Emmet toJSON:userData], nil];
}

// Reload JS context to hook-up all changes in prefernces and extensions
- (void)reload {
	// remember previously saved context
//	id ctx = self.context;
//	self.context = nil;
//	[self setupJSContext];
//	self.context = ctx;
	
	[jsc evalFunction:@"emmet_bootstrap_resetUserData" withArguments:nil];
	[self loadExtensions];
}

- (NSArray *)actionsList {
	id result = [jsc evalFunction:@"emmet_actions_getMenu" withArguments:nil];
	return [jsc convertJSObject:result toNativeType:@"object"];
}

// returns Emmet actions as menu
- (NSMenu *)actionsMenu {
	return [self actionsMenuWithAction:@selector(performMenuAction:) forTarget:self];
}

- (NSMenu *)actionsMenuWithAction:(SEL)action forTarget:(id)target {
	return [self actionsMenuWithAction:action keyboardShortcuts:nil forTarget:target];
}

- (NSMenu *)actionsMenuWithAction:(SEL)action keyboardShortcuts:(NSDictionary *)shortcuts forTarget:(id)target {
	NSMenu *rootMenu = [[NSMenu alloc] initWithTitle:@"Emmet"];
	[self createMenuItemsFromArray:[self actionsList] forMenu:rootMenu withAction:action keyboardShortcuts:shortcuts ofTarget:target];
	return [rootMenu autorelease];
}

- (void)createMenuItemsFromArray:(NSArray *)items forMenu:(NSMenu *)menu withAction:(SEL)action keyboardShortcuts:(NSDictionary *)shortcuts ofTarget:(id)target {
	[items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSDictionary *objDict = (NSDictionary *)obj;
		if ([[objDict objectForKey:@"type"] isEqual:@"submenu"]) {
			// create submenu
			NSString *submenuName = [objDict valueForKey:@"name"];
			NSMenu *submenu = [[NSMenu alloc] initWithTitle:submenuName];
			[self createMenuItemsFromArray:[objDict objectForKey:@"items"] forMenu:submenu withAction:action keyboardShortcuts:shortcuts ofTarget:target];
			
			NSMenuItem *submenuItem = [[NSMenuItem alloc] initWithTitle:submenuName action:NULL keyEquivalent:@""];
			[menu addItem:submenuItem];
			[submenuItem setSubmenu:submenu];
			
			[submenu release];
			[submenuItem release];
		} else {
			NSMenuItem *actionItem = [[NSMenuItem alloc] initWithTitle:[objDict valueForKey:@"label"] action:action keyEquivalent:@""];
			
			NSString *shortcut = [shortcuts objectForKey:[objDict valueForKey:@"name"]];
			if (shortcut != nil) {
				setKeyEquivalent(actionItem, shortcut);
			}
			
			[actionItem setTarget:target];
			[menu addItem:actionItem];
			[actionItem release];
		}
	}];
}

- (NSString *)resolveActionNameFromMenu:(NSMenuItem *)menu {
	NSString *title = [(NSMenuItem *)menu title];
	id jsActionName = [jsc evalFunction:@"emmet_actions_getActionNameForMenuTitle" withArguments:title, nil];
	return [jsc convertJSObject:jsActionName toNativeType:@"string"];
}

- (void)performMenuAction:(id)sender {
	if ([sender isKindOfClass:[NSMenuItem class]]) {
		NSString *actionName = [self resolveActionNameFromMenu:sender];
		if (actionName) {
			[self runAction:actionName];
		}
	}
}

- (void)dealloc {
	if (self->extensionsPath) {
		[self->extensionsPath release];
	}
	[super dealloc];
}

@end
