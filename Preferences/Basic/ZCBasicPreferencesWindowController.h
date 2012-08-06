//
//  ZCBasicPreferencesWindowController.h
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 8/3/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ZCBasicPreferencesWindowController : NSWindowController {
	NSArrayController *outputProfiles;
}
@property (assign) IBOutlet NSArrayController *outputProfiles;

+ (void)resetDefaults;

@end
