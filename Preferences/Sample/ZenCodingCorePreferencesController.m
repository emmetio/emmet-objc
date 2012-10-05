//
//  ZenCodingCorePreferencesController.m
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 7/29/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "ZenCodingCorePreferencesController.h"
#import "ZenCodingNotifications.h"
#import "Emmet.h"
#import "JSONKit.h"

@interface ZenCodingCorePreferencesController()
- (id)transformValueForDataSource:(id)value;
- (id)transformValueForJS:(id)value;
- (void)updatePreferencesForContext:(NSNotification *)notification;
@end

@implementation ZenCodingCorePreferencesController

@synthesize preferences;

- (id)initWithTableView:(NSTableView *)view {
	if (self = [super init]) {
		[view setDataSource:self];
		[view setDelegate:self];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
			selector:@selector(updatePreferencesForContext:)
			name:JSContextLoaded
			object:nil];
	}
	
	return self;
}

// Returns array of all available core preferences
- (NSArray *)preferences {
	if (self->preferences == nil) {
		// get defaults
		Emmet *zc = [Emmet sharedInstance];
		id jsPrefs = [zc.jsc evalFunction:@"emmet.require('preferences').list" withArguments:nil];
		self->preferences = [[zc.jsc convertJSObject:jsPrefs toNativeType:@"array"] retain];
		NSMutableDictionary *lookup = [NSMutableDictionary dictionary];
		
		[self->preferences enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			NSDictionary *d = (NSDictionary *)obj;
			NSString *key = [d objectForKey:@"name"];
			if (key != nil) {
				[lookup setObject:d forKey:key];
				[d addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:NULL];
			}
		}];
		
		// get user’s preferences
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSDictionary *_val = [defaults dictionaryForKey:Preferences];
		if (_val != nil) {
			[_val enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
				NSMutableDictionary *d = [lookup objectForKey:key];
				if (d) {
					[d setValue:obj forKey:@"value"];
				}
			}];
		}
	}
	
	return self->preferences;
}

// Saves current preferences to NSUserDefaults
- (void)save {
	Emmet *zc = [Emmet sharedInstance];
	id jsPrefs = [zc.jsc evalFunction:@"emmet.require('preferences').exportModified" withArguments:nil];
	NSDictionary *prefs = [zc.jsc convertJSObject:jsPrefs toNativeType:@"dictionary"];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:prefs forKey:Preferences];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context {
	
	if ([keyPath isEqualToString:@"value"]) {
		// passes updated preference to JS core
		NSDictionary *obj = (NSDictionary *)object;
		Emmet *zc = [Emmet sharedInstance];
//		NSLog(@"Set %@ preference to %@", [obj valueForKey:@"name"], [obj valueForKey:@"value"]);
		[zc.jsc evalFunction:@"objcSetPreference" withArguments:[obj valueForKey:@"name"], [obj valueForKey:@"value"], nil];
		
		[self save];
	}
}

// Load all current preferences into JS core
- (void)updatePreferencesForContext:(NSNotification *)notification {
	Emmet *zc = [Emmet sharedInstance];
//	NSLog(@"Load preferences");
	NSMutableDictionary *prefs = [NSMutableDictionary new];
	[self.preferences enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[prefs setObject:[obj objectForKey:@"value"] forKey:[obj objectForKey:@"name"]];
	}];
	[zc.jsc evalFunction:@"objcLoadUserPreferences" withArguments:[prefs JSONString], nil];
}

# pragma mark Table Data Source
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [self.preferences count];
}

- (id)          tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
					row:(NSInteger)row {
	NSDictionary *obj = [self.preferences objectAtIndex:row];
	NSUInteger colIx = [[tableView tableColumns] indexOfObject:tableColumn];
	if (colIx == 0) {
		return [obj valueForKey:@"name"];
	}
	
	if (colIx == 1) {
		return [self transformValueForDataSource:[obj valueForKey:@"value"]];
	}
	
	return nil;
}

- (void)tableView:(NSTableView *)tableView
   setObjectValue:(id)object
   forTableColumn:(NSTableColumn *)tableColumn
			  row:(NSInteger)row {
	NSDictionary *obj = [self.preferences objectAtIndex:row];
	NSUInteger colIx = [[tableView tableColumns] indexOfObject:tableColumn];
	if (colIx == 1) {
		[obj setValue:[self transformValueForJS:object] forKey:@"value"];
	}
}

# pragma mark Table Delegate
- (NSString *)tableView:(NSTableView *)tableView
		 toolTipForCell:(NSCell *)cell
				   rect:(NSRectPointer)rect
			tableColumn:(NSTableColumn *)tableColumn
					row:(NSInteger)row
		  mouseLocation:(NSPoint)mouseLocation {
	
	NSDictionary *obj = [self.preferences objectAtIndex:row];
	return [obj valueForKey:@"description"];
}

- (NSCell *)tableView:(NSTableView *)tableView
dataCellForTableColumn:(NSTableColumn *)tableColumn
				  row:(NSInteger)row {
	
	if (tableColumn == nil)
		return nil;
	
	NSCell *refCell = [tableColumn dataCell];
	
	NSDictionary *obj = [self.preferences objectAtIndex:row];
	NSUInteger colIx = [[tableView tableColumns] indexOfObject:tableColumn];
	if (colIx == 1) {
		NSString *valueType = [obj valueForKey:@"type"];
		if ([valueType isEqual:@"boolean"]) {
			NSButtonCell *btn = [NSButtonCell new];
			[btn setButtonType:NSSwitchButton];
			[btn setTitle:@"Enabled"];
			[btn setFont:[refCell font]];
			return btn;
		}
	}
	
	return refCell;
}

# pragma mark Value Transformation

// Transforms preference value for representation table view:
// replaces tabs and newlines with escaped characters
- (id)transformValueForDataSource:(id)value {
	if ([value isKindOfClass:[NSString class]]) {
		value = [value stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
		value = [value stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
	}
	
	return value;
}

// Transforms preference value back to its raw representation in preferences
- (id)transformValueForJS:(id)value {
	if ([value isKindOfClass:[NSString class]]) {
		value = [value stringByReplacingOccurrencesOfString:@"\\t" withString:@"\t"];
		value = [value stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
	}
	
	return value;
}

- (void)dealloc {
	if (self->preferences) {
		[self->preferences release];
	}
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

@end
