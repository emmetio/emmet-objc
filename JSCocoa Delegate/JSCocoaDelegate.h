//
//  JSCocoaDelegate.h
//  ZenCoding
//
//  Created by Siarhei Chykuyonak on 7/25/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//


#import <JavaScriptCore/JavaScriptCore.h>
#import "EMJSContext.h"

@protocol ConsoleMethods<JSExport>

- (void)log:(id)msg;

@end

@interface Console : NSObject<ConsoleMethods>

@end

@interface JSCocoaDelegate : NSObject<EMJSContext> {
    JSContext *jsc;
    BOOL _isException;
}

- (BOOL)isException;

@end
