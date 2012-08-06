//
//  ZCSnippetsPreferencesWindow.m
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 8/2/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "ZCSnippetsPreferencesWindow.h"
#import "ZCSnippetsPreferencesDataSource.h"

@interface ZCSnippetsPreferencesWindow ()

@end

@implementation ZCSnippetsPreferencesWindow
@synthesize snippetsView;

- (id)init {
    return [super initWithWindowNibName:@"ZCSnippetsPreferencesWindow"];
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
	[snippetsView setDataSource:[ZCSnippetsPreferencesDataSource new]];
}

@end
