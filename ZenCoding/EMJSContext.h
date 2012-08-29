//
//  Created by Siarhei Chykuyonak on 7/25/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EMJSContext <NSObject>

// Evaluates passed JS file
- (BOOL)evalFile:(NSString *)path;

// Evaluates passed function name with specified argumants.
// This method should register all specified arguments in JS context
// and, basically, evaluate `funcName(arg1, arg2, ...)` expression
- (id)evalFunction:(NSString *)funcName withArguments:arguments, ... NS_REQUIRES_NIL_TERMINATION;

// Should convert passed JS object to Objective-C one of
// specified type 
- (id)convertJSObject:(id)obj toNativeType:(NSString *)type;

@end
