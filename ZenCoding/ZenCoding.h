//
//  ZenCoding.h
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 2/9/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZenCodingJSContext.h"
#import "ZenCodingDefaultsKeys.h"

@interface ZenCoding : NSObject {
	id context;
	id<ZenCodingJSContext> jsc;
	NSString *extensionsPath;
}

@property (nonatomic, retain) id context;
@property (nonatomic, readonly, retain) id<ZenCodingJSContext> jsc;
@property (nonatomic, retain) NSString *extensionsPath;

+ (ZenCoding *)sharedInstance;
+ (void)setJSContextDelegateClass:(Class)class;
+ (void)loadDefaults;

// runs Zen Coding’s JS action
- (BOOL)runAction:name;

// Reload Zen Coding instance and update JS core
- (void)reload;

// returns Zen Coding actions as menu
- (NSArray *)actionsList;
- (NSMenu *)actionsMenu;
- (NSMenu *)actionsMenuWithAction:(SEL)action forTarget:(id)target;
- (void)performMenuAction:(id)sender;
@end
