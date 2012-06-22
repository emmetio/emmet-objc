//
//  ZenCodingFile.h
//  ZenCoding
//
//  Created by Siarhei Chykuyonak on 6/22/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZenCodingFile : NSObject

+ (NSString *)read:(NSString *)filePath;
+ (NSString *)locateFile:(NSString *)fileName relativeTo:(NSString *)baseFile;
+ (NSString *)createPath:(NSString *)fileName relativeTo:(NSString *)basePath;
+ (BOOL)save:(NSString *)content atPath:(NSString *)filePath;

@end
