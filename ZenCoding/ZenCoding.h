//
//  ZenCoding.h
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 2/9/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSCocoa.h"
#import "ZenCodingTextProcessorDelegate.h"

@interface ZenCoding : NSObject {
	JSCocoa* jsc;
}

@property (nonatomic, retain) id context;

+ (ZenCoding *)sharedInstance;
- (BOOL)runAction:name;
- (NSString *)processBeforePaste:(NSString *)text withDelegate:(id<ZenCodingTextProcessorDelegate>)delegate;

@end
