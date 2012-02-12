//
//  ZCTabStopGroup.h
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 2/13/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCTabStop.h"

@interface ZCTabStopGroup : NSObject {
	NSMutableArray *_list;
}

- (void)add:(ZCTabStop *)tabStop;
- (void)addForStart:(NSUInteger)start andEnd:(NSUInteger)end;
- (NSArray *)list;
- (NSUInteger)length;
- (ZCTabStop *)tabStopAtIndex:(NSUInteger)ix;

@end
