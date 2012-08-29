//
//  CodaZenEditor.h
//  ZenCodingCoda
//
//  Created by Сергей Чикуёнок on 2/19/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CodaPlugInsController.h"
#import <ZenCoding/ZenEditor.h>

#define DEFAULT_SYNTAX @"html"
#define DEFAULT_PROFILE @"xhtml"

@interface EMCodaEditor : NSObject <ZenEditor> {
	CodaTextView *tv;
}

@property (nonatomic, retain) CodaTextView *tv;

- (id)initWithCodaView:(CodaTextView *)view;

@end
