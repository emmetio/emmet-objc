//
//  ZenCodingCorePreferencesController.h
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 7/29/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZenCodingCorePreferencesController : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, readonly, retain) NSArray *preferences;

//- (id)initWithController:(NSArrayController *)controller;
- (id)initWithTableView:(NSTableView *)view;
//- (NSArray *)preferences;
- (void)save;

@end
