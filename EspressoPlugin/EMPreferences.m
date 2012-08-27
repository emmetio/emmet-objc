//
//  EMPreferences.m
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 8/27/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "EMPreferences.h"

@implementation EMPreferences

- (BOOL)canPerformActionWithContext:(id)context {
	return YES;
}

- (BOOL)performActionWithContext:(NSObject *)context error:(NSError **)outError {
	if (prefs == nil) {
		prefs = [ZCBasicPreferencesWindowController new];
		[prefs hideTabExpanderControl];
	}
	
	[prefs showWindow:self];
	return YES;
}

@end
