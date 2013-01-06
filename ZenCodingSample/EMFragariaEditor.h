//
//  EMFragariaEditor.h
//  Emmet
//
//  Created by Sergey Chikuyonok on 1/6/13.
//  Copyright (c) 2013 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MGSFragaria/MGSFragaria.h>
#import "EmmetEditor.h"

@interface EMFragariaEditor : NSObject <EmmetEditor> {
	MGSFragaria *_backend;
	NSTextView *tv;
}

- (id)initWithBackend:(MGSFragaria *)backend;

@end
