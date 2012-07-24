//
//  JSCocoaDelegate.m
//  ZenCoding
//
//  Created by Siarhei Chykuyonak on 7/25/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "JSCocoaDelegate.h"

@implementation JSCocoaDelegate

- (id)init {
	if (self = [super init]) {
		ctx = [JSCocoa new];
		ctx.useAutoCall = NO;
		ctx.useJSLint = NO;
	}
	
	return self;
}

- (BOOL)evalFile:(NSString *)path {
	return [ctx evalJSFile:path];
}

- (id)evalFunction:(NSString *)funcName withArguments:(id)firstArg, ... {
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
		[ctx setObject:[arguments objectAtIndex:i] withName:[argNames lastObject]];
	}
	
	// create JS string to evaluate
	NSString *jsString = [NSString stringWithFormat:@"%@(%@)", funcName, [argNames componentsJoinedByString:@", "]];
	
	JSValueRef result = [ctx evalJSString:jsString];
	
	// unregister all arguments from JS context
	for (NSString *argName in argNames) {
		[ctx removeObjectWithName:argName];
	}
	
	return (id)result;
}


- (id)convertJSObject:(id)obj toNativeType:(NSString *)type {
	if ([type isEqual:@"bool"] || [type isEqual:@"boolean"]) {
		return (id)[ctx toBool:(JSValueRef)obj];
	}
	
	if ([type isEqual:@"string"]) {
		return (id)[ctx toString:(JSValueRef)obj];
	}
	
	return (id)[ctx toObject:(JSValueRef)obj];
}

- (void)dealloc {
	[ctx release];
	[super dealloc];
}

@end
