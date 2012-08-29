//
//  ZCTextmatePlugin.h
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 8/11/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Emmet.h"
#import "EMTextMateEditor.h"
#import "EMBasicPreferencesWindowController.h"

@protocol TMPlugInController
- (CGFloat)version;
@end

@interface EMTextmatePlugin : NSObject {
	EMTextMateEditor *editor;
	EMBasicPreferencesWindowController *prefs;
}

+ (NSBundle *)bundle;

- (id)initWithPlugInController:(id <TMPlugInController>)aController;

- (void)installMenuItems;

@end
