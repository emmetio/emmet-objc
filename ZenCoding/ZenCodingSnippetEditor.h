//
//  ZenCodingSnippetEditor.h
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 3/13/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define SNIPPET_EDITOR_OK      0
#define SNIPPET_EDITOR_CANCEL  1
#define SNIPPET_DEFAULT_SYNTAX @"common"

@interface ZenCodingSnippetEditor : NSWindowController {
	NSMutableDictionary *editObject;
	NSTextView *textView;
}

@property (assign) IBOutlet NSTextView *textView;
- (NSDictionary *)openAddDialogForWindow:(NSWindow *)wnd;
- (NSDictionary *)openEditDialog:(NSDictionary *)editObj forWindow:(NSWindow *)wnd;

@end
