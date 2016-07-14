// 
//  Created by Сергей Чикуёнок on 2/6/12.
//  Copyright 2012 Аймобилко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol EmmetEditor<JSExport>

@property (nonatomic, assign) NSRange selectionRange;

@property (nonatomic, assign) NSUInteger caretPos;


- (NSRange)currentLineRange;
- (NSString *)currentLine;
- (NSString *)content;
- (NSString *)syntax;
- (NSString *)profileName;
- (NSString *)selection;

JSExportAs(replaceContentWithValue_from_to_withoutIndentation,
- (void)replaceContentWithValue:(NSString *)value from:(NSUInteger)start to:(NSUInteger)end withoutIndentation:(BOOL)indent
);

- (NSString *)prompt:(NSString *)label;

@optional
- (NSString *)filePath;

@end
