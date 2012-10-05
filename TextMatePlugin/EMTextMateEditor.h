//
//  TextMateZenEditor.h
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 8/11/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OakTextView.h"
#import "EmmetEditor.h"

typedef struct _TMLocation {
	NSUInteger startLine;
	NSUInteger startCol;
	NSUInteger endLine;
	NSUInteger endCol;
} TMLocation;

TMLocation convertRangeToLocation(NSRange range, NSString *string);

@interface EMTextMateEditor : NSObject <EmmetEditor>

@end