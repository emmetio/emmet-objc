//
//  EMGenericAction.h
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 8/25/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMGenericAction : NSObject  {
	NSDictionary *actionParams;
}

- (id)initWithDictionary:(NSDictionary *)dictionary bundlePath:(NSString *)bundlePath;
- (BOOL)performActionWithContext:(id)context error:(NSError **)outError;
- (BOOL)canPerformActionWithContext:(id)context;

@end
