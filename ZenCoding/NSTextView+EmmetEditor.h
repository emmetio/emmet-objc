//
//  Created by Сергей Чикуёнок on 2/6/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "EmmetEditor.h"
#import "Emmet.h"

#define DEFAULT_PROFILE @"xhtml"
#define DEFAULT_SYNTAX @"html"

@interface NSTextView (NSTextView_EmmetEditor) <EmmetEditor>

@end
