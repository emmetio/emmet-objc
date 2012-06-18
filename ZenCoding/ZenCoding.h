//
//  ZenCoding.h
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 2/9/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSCocoa.h"

@interface ZenCoding : NSObject {
	id context;
	JSCocoa *jsc;
	NSString *extensionsPath;
}

@property (nonatomic, retain) id context;
@property (nonatomic, readonly, retain) JSCocoa *jsc;
@property (nonatomic, retain) NSString *extensionsPath;

+ (ZenCoding *)sharedInstance;
- (BOOL)runAction:name;
- (JSValueRef)evalFunction:(NSString *)funcName withArguments:arguments, ... NS_REQUIRES_NIL_TERMINATION;

// returns Zen Coding actions as menu
- (NSArray *)actionsList;
- (NSMenu *)actionsMenu;
- (NSMenu *)actionsMenuWithAction:(SEL)action forTarget:(id)target;
- (void)performMenuAction:(id)sender;
@end
