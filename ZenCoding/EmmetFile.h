//
//  Created by Siarhei Chykuyonak on 6/22/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmmetFile : NSObject

+ (NSString *)read:(NSString *)filePath ofSize:(NSUInteger)size withEncoding:(NSStringEncoding)enc;
+ (NSString *)read:(NSString *)filePath ofSize:(NSUInteger)size;
+ (NSString *)readText:(NSString *)filePath;
+ (NSString *)locateFile:(NSString *)fileName relativeTo:(NSString *)baseFile;
+ (NSString *)createPath:(NSString *)fileName relativeTo:(NSString *)basePath;
+ (BOOL)save:(NSString *)content atPath:(NSString *)filePath;

@end
