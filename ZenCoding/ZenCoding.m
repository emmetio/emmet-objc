//
//  ZenCoding.m
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 2/9/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import "ZenCoding.h"

@implementation ZenCoding

@synthesize context;

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
        jsc = [JSCocoa new];
		jsc.useAutoCall = NO;
		jsc.useJSLint = NO;
		[jsc evalJSFile:[[NSBundle mainBundle] pathForResource:@"zencoding" ofType:@"js"]];
		[jsc evalJSFile:[[NSBundle mainBundle] pathForResource:@"objc-zeneditor-wrap" ofType:@"js"]];
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
	[jsc setObject:name withName:@"__objcActionName"];
	JSValueRef returnVal = [jsc callJSFunctionNamed:@"objcRunAction" withArguments:name, nil];
	[jsc removeObjectWithName:@"__objcActionName"];
	return [jsc toBool:returnVal];
}

- (NSString *)processBeforePaste:(NSString *)text withDelegate:(id<ZenCodingTextProcessorDelegate>)delegate {
	[jsc setObject:text withName:@"__objcParam1"];
	[jsc setObject:delegate withName:@"__objcParam2"];
	
	JSValueRef returnVal = [jsc callJSFunctionNamed:@"objcProcessTextBeforePasteWithDelegate" withArguments:text, delegate, nil];
	[jsc removeObjectWithName:@"__objcParam1"];
	[jsc removeObjectWithName:@"__objcParam2"];
	
	return [jsc toString:returnVal];
}


- (void)dealloc {
	[jsc release];
	[super dealloc];
}

@end
