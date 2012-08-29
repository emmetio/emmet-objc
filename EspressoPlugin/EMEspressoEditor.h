//
//  EspressoEmmetEditor.h
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 8/25/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Emmet.h"

@interface EMEspressoEditor : NSObject <EmmetEditor> {
	NSObject *ctx;
}

- (id)initWithContext:(NSObject *)context;

@end
