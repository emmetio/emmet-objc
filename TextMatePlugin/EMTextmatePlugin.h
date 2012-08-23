//
//  ZCTextmatePlugin.h
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 8/11/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZenCoding.h"
#import "TextMateEmmetEditor.h"
#import "ZCBasicPreferencesWindowController.h"

@protocol TMPlugInController
- (CGFloat)version;
@end

@interface EMTextmatePlugin : NSObject {
	TextMateEmmetEditor *editor;
	ZCBasicPreferencesWindowController *prefs;
}

+ (NSBundle *)bundle;

- (id)initWithPlugInController:(id <TMPlugInController>)aController;

- (void)installMenuItems;

@end
