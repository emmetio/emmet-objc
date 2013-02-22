//
//  Created by Sergey Chikuyonok on 6/22/12.
//  Copyright (c) 2012 Аймобилко. All rights reserved.
//

#import "EmmetFile.h"

static BOOL isURL(NSString *path) {
	return [path hasPrefix:@"http://"] || [path hasPrefix:@"https://"];
}

@implementation EmmetFile

+ (NSString *)read:(NSString *)filePath ofSize:(NSUInteger)size withEncoding:(NSStringEncoding)enc {
	NSString *content = nil;
	if (isURL(filePath)) {
		NSURL *url = [NSURL URLWithString:filePath];
		NSURLRequest *req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:2.0];
		NSError *error;
		NSURLResponse *response;
		NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
		if (data) {
			content = [[NSString alloc] initWithData:data encoding:enc];
		} else {
			NSLog(@"Error while loading URL: %@", error);
		}
	} else {
		content = [NSString stringWithContentsOfFile:filePath encoding:enc error:nil];
	}
	
	if (size > 0 && content) {
		content = [content substringToIndex:size];
	}
	
	return content;
}

+ (NSString *)read:(NSString *)filePath ofSize:(NSUInteger)size {
	return [EmmetFile read:filePath ofSize:size withEncoding:NSASCIIStringEncoding];
}

+ (NSString *)readText:(NSString *)filePath {
	return [EmmetFile read:filePath ofSize:0 withEncoding:NSUTF8StringEncoding];
}

+ (NSString *)locateFile:(NSString *)fileName relativeTo:(NSString *)baseFile {
	if (isURL(fileName)) {
		return fileName;
	}
	
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
