//
//  ZenCodingPromptDialogController.h
//  ZenCoding
//
//  Created by Sergey on 2/17/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define MODAL_ACTION_OK     0
#define MODAL_ACTION_CANCEL 1

#define MODAL_DEFAULT_LABEL @"Enter value"

@interface ZenCodingPromptDialogController : NSWindowController

@property (assign) IBOutlet NSTextField *label;
@property (assign) IBOutlet NSTextField *inputField;

- (IBAction)performOK:(id)sender;
- (IBAction)performCancel:(id)sender;

+ (NSString *)prompt:(NSString *)labelText;
- (NSString *)promptWithLabel:(NSString *)labelText;

@end
