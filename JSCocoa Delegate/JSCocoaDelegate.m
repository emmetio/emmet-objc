//
//  JSCocoaDelegate.m
//  ZenCoding
//
//  Created by Siarhei Chykuyonak on 7/25/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "JSCocoaDelegate.h"

@implementation Console

- (void)log:(id)msg {
    if (msg) {
        NSLog(@"%@", [msg description]);
    } else {
        NSLog(@"null");
    }
}

@end

@implementation JSCocoaDelegate

- (instancetype)init {
    if (self = [super init]) {
        jsc = [JSContext new];
        jsc[@"console"] = [Console new];
        _isException = NO;
        [jsc setExceptionHandler:^(JSContext *ctx, JSValue *ex) {
            NSLog(@"JSContext %@ exception: %@", ctx, ex);
            _isException = YES;
        }];
    }
    return self;
}

- (void)dealloc {
    [jsc release];
    [super dealloc];
}

- (BOOL)isException {
    if (_isException == YES) {
        _isException = NO;
        return YES;
    }
    
    return NO;
}

// Evaluates passed JS file
- (BOOL)evalFile:(NSString *)path {
    NSError *error = nil;
    NSString *scriptContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        return NO;
    }
    
    [jsc evaluateScript:scriptContent];
    return [self isException];
}

// Evaluates passed function name with specified argumants.
// This method should register all specified arguments in JS context
// and, basically, evaluate `funcName(arg1, arg2, ...)` expression
- (id)evalFunction:(NSString *)funcName withArguments:firstArg, ... {
    JSValue *func = jsc[funcName];
    if (func == nil) {
        return nil;
    }
    
    // Convert args to array
    id arg;
    NSMutableArray *arguments = [NSMutableArray array];
    
    if (firstArg) {
        [arguments addObject:firstArg];
        
        va_list	args;
        va_start(args, firstArg);
        while ((arg = va_arg(args, id)))
            [arguments addObject:arg];
        va_end(args);
    }
    
    // NSLog(@"Call function %@ with arguments: %@", funcName, arguments);
    return [func callWithArguments:arguments];
}

// Should convert passed JS object to Objective-C one of
// specified type
- (id)convertJSObject:(id)val toNativeType:(NSString *)type {
    if ([type isEqual:@"bool"] || [type isEqual:@"boolean"]) {
        return @([val toBool]);
    }
    
    if ([type isEqual:@"string"]) {
        return [val toObjectOfClass:[NSString class]];
    }
    
    return [val toObject];
}

@end

