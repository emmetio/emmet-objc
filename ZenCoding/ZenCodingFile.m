//
//  ZenCodingFile.m
//  ZenCoding
//
//  Created by Sergey Chikuyonok on 6/22/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "ZenCodingFile.h"

@implementation ZenCodingFile

+ (NSString *)read:(NSString *)filePath {
	return [NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil];
}

+ (NSString *)locateFile:(NSString *)fileName relativeTo:(NSString *)baseFile {
	baseFile = [baseFile stringByDeletingLastPathComponent];
	int loop = 100;
	NSString *curPath;
	NSFileManager *fm = [NSFileManager defaultManager];
	
	while (![baseFile isEqual:@""] && ![baseFile isEqual:@"/"] && loop > 0) {
		curPath = [self createPath:fileName relativeTo:baseFile];
//		NSLog(@"Current path: %@", curPath);
		if ([fm fileExistsAtPath:curPath]) {
			return curPath;
		}
		
		baseFile = [baseFile stringByDeletingLastPathComponent];
		loop--;
	}
	
	return nil;
}

+ (NSString *)createPath:(NSString *)fileName relativeTo:(NSString *)basePath {
	NSFileManager *fm = [NSFileManager defaultManager];
	NSURL *baseURL = [NSURL fileURLWithPath:basePath];
	BOOL isDir;
	if ([fm fileExistsAtPath:[baseURL path] isDirectory:&isDir] && !isDir) {
		baseURL = [baseURL URLByDeletingLastPathComponent];
	}
	
	NSURL *fileURL = [NSURL fileURLWithPathComponents:[NSArray arrayWithObjects:[baseURL path], fileName, nil]];
	return [[fileURL path] stringByStandardizingPath];
}

+ (BOOL)save:(NSString *)content atPath:(NSString *)filePath {
	return [content writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

@end
