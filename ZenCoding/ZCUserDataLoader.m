//
//  Loads user data (snippets, preferences etc) from NSUserDefaults
//
//  Created by Sergey Chikuyonok on 8/1/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "ZCUserDataLoader.h"
#import "ZenCoding.h"
#import "NSMutableDictionary+ZCUtils.h"
#import "JSONKit.h"

@implementation ZCUserDataLoader

// Returns all user data as single autoreleased dictionary
+ (NSDictionary *)userData {
	NSDictionary *data = [NSMutableDictionary dictionary];
	NSArray *keys = [NSArray arrayWithObjects:@"variables", @"snippets", @"syntaxProfiles", @"preferences", nil];
	
	// add non-nil values only
	[keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		id val = [[ZCUserDataLoader class] performSelector:NSSelectorFromString(obj)];
		if (val != nil) {
			[data setValue:val forKey:obj];
		}
	}];
	
	return data;
}

// Returns autoreleased dictionary of all user-defined variables
+ (NSDictionary *)variables {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *userVars = [defaults arrayForKey:Variables];
	
	if (userVars) {
		NSMutableDictionary *d = [NSMutableDictionary dictionary];
		for (NSDictionary *item in userVars) {
			[d setObject:[item objectForKey:@"value"] forKey:[item objectForKey:@"name"]];
		}
		
		return d;
	}
	
	return nil;
}

// Returns autoreleased dictionary of all user-defined snippets and abbreviations
//+ (NSDictionary *)snippets {
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//	NSMutableDictionary *result = [NSMutableDictionary dictionary];
//	NSDictionary *scopes = [NSDictionary dictionaryWithObjectsAndKeys:
//							@"abbreviations", Abbreviations,
//							@"snippets", Snippets,
//							nil];
//	
//	[scopes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//		NSArray *scopeData = [defaults arrayForKey:key];
//		if (scopeData) {
//			for (NSDictionary *item in scopeData) {
//				NSString *syntax = [item objectForKey:@"syntax"];
//				NSMutableDictionary *syntaxCtx = [[result dictionaryForKey:syntax] dictionaryForKey:obj];
//				[syntaxCtx setObject:[item objectForKey:@"value"] forKey:[item objectForKey:@"name"]];
//			}
//		}
//	}];
//		
//	return [result count] ? result : nil;
//}

+ (NSArray *)snippets {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults arrayForKey:Snippets];
}

+ (NSDictionary *)syntaxProfiles {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *output = [defaults dictionaryForKey:Output];
	if (output) {
		NSMutableDictionary *result = [NSMutableDictionary dictionary];
		[output enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
			[result setObject:[ZCUserDataLoader createOutputProfileFromDict:obj] forKey:key];
//			[[result dictionaryForKey:key] setObject:[ZCUserDataLoader createOutputProfileFromDict:obj] forKey:@"profile"];
		}];
		return result;
	}
	
	return nil;
}

+ (NSDictionary *)createOutputProfileFromDict:(NSDictionary *)dict {
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

// Returns array of all available core preferences
+ (NSDictionary *)preferences {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults dictionaryForKey:Preferences];
}

// Reset all user-defined data
+ (void)resetDefaults {
	NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
	for (NSString *key in [defaultsDictionary allKeys]) {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
}


@end
