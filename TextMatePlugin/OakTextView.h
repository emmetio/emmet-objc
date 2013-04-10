@interface OakTextView : NSView <NSTextInput>
- (NSString *)stringValue;
- (void)insertSnippetWithOptions:(NSDictionary*)someOptions;
- (void)setSelectionString:(NSString*)aSelectionString;
- (NSRange)selectedRange;
- (id)xmlRepresentationForSelection;
- (NSDictionary *)environmentVariables;

- (void)goToLineNumber:(id)fp8;
- (void)goToColumnNumber:(id)fp8;
- (void)selectToLine:(id)fp8 andColumn:(id)fp12;

// Actions
- (void)deleteSelection:(id)sender;

// TextMate 2 API
- (id)scopeContext;
- (NSString *)scope;
- (NSString *)filePath;
@property (nonatomic, assign) id          delegate;
@property (nonatomic, retain) NSCursor*   ibeamCursor;
@property (nonatomic, retain) NSFont*     font;
@property (nonatomic, assign) BOOL        antiAlias;
@property (nonatomic, assign) size_t      tabSize;
@property (nonatomic, assign) BOOL        showInvisibles;
@property (nonatomic, assign) BOOL        softWrap;
@property (nonatomic, assign) BOOL        softTabs;
@property (nonatomic, readonly) BOOL      continuousIndentCorrections;

@property (nonatomic, readonly) BOOL      hasMultiLineSelection;
@property (nonatomic, readonly) BOOL      hasSelection;
@property (nonatomic, retain) NSString*   selectionString;
@property (nonatomic, retain) NSString*   string;


@end
