//
//  ZCSnippetsPreferencesDataSource.m
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 8/2/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "ZCSnippetsPreferencesDataSource.h"
#import "ZCUserDataLoader.h"
#import "ZenCoding.h"

static NSMutableArray *snippetsData;

@interface ZCSnippetsPreferencesDataSource ()
- (NSArray *)snippetsData;
- (NSMutableDictionary *)createEntry:(NSString *)label;
@end

@implementation ZCSnippetsPreferencesDataSource

- (NSArray *)snippetsData {
	if (snippetsData != nil)
		return snippetsData;
	snippetsData = [NSMutableArray new];
	
	
	// make sure defaults are loaded
	[ZenCoding loadDefaults];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *syntaxes = [defaults arrayForKey:@"syntax"];
	
	// create snippets representation
	NSArray *userSnippets = [ZCUserDataLoader snippets];
	NSMutableDictionary *snippetsLookup = [NSMutableDictionary new];
	[userSnippets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSString *syntax = [obj objectForKey:@"syntax"];
		if (syntax) {
			if (![snippetsLookup objectForKey:syntax]) {
				[snippetsLookup setObject:[NSMutableArray array] forKey:syntax];
			}
			
			[[snippetsLookup objectForKey:syntax] addObject:obj];
		}
	}];
	
	if (syntaxes) {
		[syntaxes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			// fill first level with syntaxes
			NSString *syntax = [obj objectForKey:@"id"];
			NSMutableDictionary *child = [self createEntry:[obj objectForKey:@"title"]];
			[snippetsData addObject:child];
			if ([snippetsLookup objectForKey:syntax]) {
				[child setObject:[snippetsLookup objectForKey:syntax] forKey:@"children"];
			}
		}];
	}
	
	[snippetsLookup release];
	
	return snippetsData;
}

- (NSMutableDictionary *)createEntry:(NSString *)label {
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
			label, @"label",
			[NSMutableArray array], @"children",
			nil];
	
	return dict;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	if (item == nil) {
		// root object
		return [[self snippetsData] count];
	}
	
	id ctx = [item objectForKey:@"children"];
	if (ctx != nil) {
		// syntax
		return [ctx count];
	}
	
	// otherwise, it's a leaf node (snippet)
	return 0;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return (item == nil) ? YES : ([item objectForKey:@"children"] != nil);
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    return (item == nil)
		? [[self snippetsData] objectAtIndex:index]
		: [[item objectForKey:@"children"] objectAtIndex:index];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	if (item == nil) {
		// root item (shouldn't be here)
		return @"ROOT";
	}
	
	NSString *val = [item objectForKey:@"label"];
	if (val != nil) {
		// syntax node
		return val;
	}
	
	// leaf node
	return [item objectForKey:@"name"];
}

@end
