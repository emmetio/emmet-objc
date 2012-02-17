//
//  ZenCodingAppDelegate.h
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 1/12/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZenCoding.h"
#import "ZenCodingPromptDialogController.h"

@interface ZenCodingAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	
	IBOutlet NSTextView *textArea;
}

@property (assign) IBOutlet NSWindow *window;

@end
