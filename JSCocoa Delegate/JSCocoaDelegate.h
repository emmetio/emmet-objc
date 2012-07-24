//
//  JSCocoaDelegate.h
//  ZenCoding
//
//  Created by Siarhei Chykuyonak on 7/25/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZenCodingJSContext.h"
#import "JSCocoa.h"

@interface JSCocoaDelegate : NSObject <ZenCodingJSContext> {
	JSCocoa *ctx;
}

@end
