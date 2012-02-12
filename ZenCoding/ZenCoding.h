//
//  ZenCoding.h
//  ZenCoding
//
//  Created by Сергей Чикуёнок on 2/9/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSCocoa.h"

@interface ZenCoding : NSObject {
	JSCocoa* jsc;
}

@property (nonatomic, retain) id context;

- (BOOL)runAction:name;

@end
