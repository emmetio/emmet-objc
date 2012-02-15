//
//  ZCTabStopStructure.h
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 2/13/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCTabStopGroup.h"

@interface ZCTabStopStructure : NSObject {
	NSDictionary *_groups;
	
}

- (void)addTabStopToGroup:(NSString *)groupName start:(NSUInteger)start end:(NSUInteger)end;
- (NSDictionary *)groups;
- (NSUInteger)tabStopsCount;
- (NSArray *)sortedGroupKeys;
- (ZCTabStop *)firstTabStop;
- (ZCTabStopGroup *)namedGroup:(NSString *)name;
- (ZCTabStop *)tabStop:(NSString *)name atIndex:(NSUInteger)ix;

@end
