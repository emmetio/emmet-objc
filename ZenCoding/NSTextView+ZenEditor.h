//
//  NSTextView+ZenEditor.h
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 2/6/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "ZenEditor.h"

#define DEFAULT_PROFILE @"xhtml"
#define DEFAULT_SYNTAX @"html"

@interface NSTextView (NSTextView_ZenEditor) <ZenEditor>

@end
