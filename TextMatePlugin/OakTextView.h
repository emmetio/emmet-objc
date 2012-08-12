@interface OakTextView : NSView <NSTextInput>
- (NSString *)stringValue;
- (void)insertSnippetWithOptions:(NSDictionary*)someOptions;
- (id)scope;
- (void)setSelectionString:(NSString*)aSelectionString;
- (NSRange)selectedRange;
- (id)xmlRepresentationForSelection;
- (NSDictionary *)environmentVariables;

- (void)goToLineNumber:(id)fp8;
- (void)goToColumnNumber:(id)fp8;
- (void)selectToLine:(id)fp8 andColumn:(id)fp12;

// Actions
- (void)deleteSelection:(id)sender;


@end
