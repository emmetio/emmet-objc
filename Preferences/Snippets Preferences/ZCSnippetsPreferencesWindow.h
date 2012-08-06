//
//  ZCSnippetsPreferencesWindow.h
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 8/2/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ZCSnippetsPreferencesWindow : NSWindowController {
	NSOutlineView *snippetsView;
}

@property (assign) IBOutlet NSOutlineView *snippetsView;

@end
