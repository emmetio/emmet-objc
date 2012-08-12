//
//  ZCTextmatePlugin.h
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 8/11/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZenCoding.h"
#import "TextMateZenEditor.h"

@protocol TMPlugInController
- (CGFloat)version;
@end

@interface ZCTextmatePlugin : NSObject {
	TextMateZenEditor *editor;
}

+ (NSBundle *)bundle;

- (id)initWithPlugInController:(id <TMPlugInController>)aController;

- (void)installMenuItems;

@end
