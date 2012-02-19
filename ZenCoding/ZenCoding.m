//
//  ZenCoding.m
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 2/9/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import "ZenCoding.h"

@implementation ZenCoding

@synthesize context, jsc;

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
    self = [super init];
    if (self) {
        self->jsc = [JSCocoa new];
		
		jsc.useAutoCall = NO;
		jsc.useJSLint = NO;
		
		NSBundle *bundle = [NSBundle bundleForClass:[self class]];
		[jsc evalJSFile:[bundle pathForResource:@"zencoding" ofType:@"js"]];
		[jsc evalJSFile:[bundle pathForResource:@"objc-zeneditor-wrap" ofType:@"js"]];
    }
    
    return self;
}

- (void)setContext:(id)ctx {
	if (self->context != ctx) {
		self->context = nil;
		self->context = [ctx retain];
		[jsc setObject:ctx withName:@"__objcContext"];
		[jsc callJSFunctionNamed:@"objcSetContext" withArguments:ctx, nil];
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
	
	NSLog(@"Eval JS: %@", jsString);
	JSValueRef result = [jsc evalJSString:jsString];
	
	// unregister all arguments from JS context
	for (NSString *argName in argNames) {
		[jsc removeObjectWithName:argName];
	}
	
	return result;
}


- (void)dealloc {
	[super dealloc];
}

@end
