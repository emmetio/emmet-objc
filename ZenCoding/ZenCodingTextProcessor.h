//
//  ZenCodingTextProcessor.h
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 2/13/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZenCoding.h"
#import "ZenCodingTextProcessorDelegate.h"
#import "ZCTabStopStructure.h"

#define CARET_PLACEHOLDER @"{%::zen-caret::%}"
#define CARET_GROUP @"carets"


@interface ZenCodingTextProcessor : NSObject <ZenCodingTextProcessorDelegate> 
@property (nonatomic, readonly, retain) NSString *originalText;
@property (nonatomic, readonly) NSDictionary *placeholders;
@property (nonatomic, readonly) NSArray *marks;
@property (nonatomic, readonly) NSString *processedText;
@property (nonatomic, readonly) ZCTabStopStructure *tabStops;

- (id)initWithText:(NSString *)text;

@end
