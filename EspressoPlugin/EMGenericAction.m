//
//  EMGenericAction.m
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 8/25/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "EMGenericAction.h"
#import "EspressoSDK.h"
#import "ZenCoding.h"
#import "JSCocoaDelegate.h"
#import "EMEspressoEditor.h"

static NSString * const EmmetBundleIdentifier = @"io.emmet.EspressoPlugin";

@implementation EMGenericAction

+ (NSBundle *)bundle {
	return [NSBundle bundleWithIdentifier:EmmetBundleIdentifier];
}

+ (void)initialize {
	[ZenCoding setJSContextDelegateClass:[JSCocoaDelegate class]];
	NSBundle *bundle = [EMGenericAction bundle];
	[ZenCoding addCoreFile:[bundle pathForResource:@"textmate-bootstrap" ofType:@"js"]];
}

- (id)initWithDictionary:(NSDictionary *)dictionary bundlePath:(NSString *)bundlePath {
	actionParams = [dictionary copy];
	return [super init];
}

- (BOOL)canPerformActionWithContext:(id)context {
	return YES;
}

- (BOOL)performActionWithContext:(NSObject *)context error:(NSError **)outError {
	NSString *actionName = [actionParams objectForKey:@"name"];
	ZenCoding *zc = [ZenCoding sharedInstance];
	EMEspressoEditor *editor = [[[EMEspressoEditor alloc] initWithContext:context] autorelease];
	zc.context = editor;
	
	if ([actionName isEqualToString:@"expand_abbreviation"]) {
		SXSelector *cssSelector = [SXSelector selectorWithString:@"property-list.block.css, property-list.block.css *"];
		SXZone *zone = [context.syntaxTree zoneAtCharacterIndex:[editor caretPos]];
		if ([cssSelector matches:zone] && [editor selectionRange].length > 0) {
			// If we are in a CSS zone, delete the selected range (because it
			// likely is CodeSense filling in, and will screw up our abbreviation)
			CETextRecipe *recipe = [CETextRecipe new];
			[recipe deleteRange:[editor selectionRange]];
			[context applyTextRecipe:recipe];
			[recipe release];
		}
	}
	
	BOOL result = [zc runAction:actionName];
	zc.context = nil;
	return result;
}

- (void)dealloc {
	[actionParams release];
	[super dealloc];
}

@end
