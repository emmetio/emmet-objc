//
//  Created by Сергей Чикуёнок on 2/9/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmmetFile.h"
#import "EmmetEditor.h"
#import "EMJSContext.h"
#import "EMDefaultsKeys.h"
#import "EMNotifications.h"

void setKeyEquivalent(NSMenuItem *menuItem, NSString *key);

@interface Emmet : NSObject {
	id context;
	id<EMJSContext> jsc;
	NSString *extensionsPath;
}

@property (nonatomic, retain) id context;
@property (nonatomic, readonly, retain) id<EMJSContext> jsc;
@property (nonatomic, retain) NSString *extensionsPath;

+ (Emmet *)sharedInstance;
+ (void)setJSContextDelegateClass:(Class)class;
+ (void)loadDefaults;
+ (void)addCoreFile:(NSString *)file;

// runs Emmet’s JS action
- (BOOL)runAction:name;

// Reload Emmet instance and update JS core
- (void)reload;

// returns Emmet actions as menu
- (NSArray *)actionsList;
- (NSMenu *)actionsMenu;
- (NSMenu *)actionsMenuWithAction:(SEL)action forTarget:(id)target;
- (NSMenu *)actionsMenuWithAction:(SEL)action keyboardShortcuts:(NSDictionary *)shortcuts forTarget:(id)target;
- (void)performMenuAction:(id)sender;
@end
