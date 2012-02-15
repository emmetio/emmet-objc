var objcZenEditor = (function() {
	var ctx;

	function rangeToObj(range) {
		return  {
			start: range.location,
			end: range.location + range.length
		};
	}

	return {
		/**
		 * Setup underlying editor context. You should call this method 
		 * <code>before</code> using any Zen Coding action.
		 * @memberOf IZenEditor
		 * @param {Object} context
		 */
		setContext: function(context) {
			ctx = context;
		},
		
		/**
		 * Returns character indexes of selected text: object with <code>start</code>
		 * and <code>end</code> properties. If there's no selection, should return 
		 * object with <code>start</code> and <code>end</code> properties referring
		 * to current caret position
		 * @return {Object}
		 * @example
		 * var selection = zen_editor.getSelectionRange();
		 * alert(selection.start + ', ' + selection.end); 
		 */
		getSelectionRange: function() {
			return rangeToObj(ctx.selectionRange());
		},
		
		/**
		 * Creates selection from <code>start</code> to <code>end</code> character
		 * indexes. If <code>end</code> is ommited, this method should place caret 
		 * and <code>start</code> index
		 * @param {Number} start
		 * @param {Number} [end]
		 * @example
		 * zen_editor.createSelection(10, 40);
		 * 
		 * //move caret to 15th character
		 * zen_editor.createSelection(15);
		 */
		createSelection: function(start, end) {
			var range = NSMakeRange(start, end - start);
			ctx.setSelectionRange(range);
		},
		
		/**
		 * Returns current line's start and end indexes as object with <code>start</code>
		 * and <code>end</code> properties
		 * @return {Object}
		 * @example
		 * var range = zen_editor.getCurrentLineRange();
		 * alert(range.start + ', ' + range.end);
		 */
		getCurrentLineRange: function() {
			return rangeToObj(ctx.currentLineRange());
		},
		
		/**
		 * Returns current caret position
		 * @return {Number}
		 */
		getCaretPos: function(){
			return Number(ctx.caretPos());
		},
		
		/**
		 * Set new caret position
		 * @param {Number} pos Caret position
		 */
		setCaretPos: function(pos){
			ctx.setCaretPos(pos);
		},
		
		/**
		 * Returns content of current line
		 * @return {String}
		 */
		getCurrentLine: function() {
			return ctx.currentLine();
		},
		
		/**
		 * Replace editor's content or it's part (from <code>start</code> to 
		 * <code>end</code> index). If <code>value</code> contains 
		 * <code>caret_placeholder</code>, the editor will put caret into 
		 * this position. If you skip <code>start</code> and <code>end</code>
		 * arguments, the whole target's content will be replaced with 
		 * <code>value</code>. 
		 * 
		 * If you pass <code>start</code> argument only,
		 * the <code>value</code> will be placed at <code>start</code> string 
		 * index of current content. 
		 * 
		 * If you pass <code>start</code> and <code>end</code> arguments,
		 * the corresponding substring of current target's content will be 
		 * replaced with <code>value</code>. 
		 * @param {String} value Content you want to paste
		 * @param {Number} [start] Start index of editor's content
		 * @param {Number} [end] End index of editor's content
		 * @param {Boolean} [no_indent] Do not auto indent <code>value</code>
		 */
		replaceContent: function(value, start, end, no_indent) {
			var _ = zen_coding.require('_');
			var content = this.getContent();
			var caretPos = this.getCaretPos();
			start = start || 0;
			end = _.isUndefined(end) ? content.length : end;
					 
			ctx.replaceContentWithValue_from_to_withoutIndentation(value, start, end, !!no_indent);
		},
		
		/**
		 * Returns editor's content
		 * @return {String}
		 */
		getContent: function(){
			return ctx.content();
		},
		
		/**
		 * Returns current editor's syntax mode
		 * @return {String}
		 */
		getSyntax: function(){
			return ctx.syntax();
		},
		
		/**
		 * Returns current output profile name (@see zen_coding#setupProfile)
		 * @return {String}
		 */
		getProfileName: function() {
			return ctx.profileName();
		},
		
		/**
		 * Ask user to enter something
		 * @param {String} title Dialog title
		 * @return {String} Entered data
		 * @since 0.65
		 */
		prompt: function(title) {
			return ctx.prompt(title);
		},
		
		/**
		 * Returns current selection
		 * @return {String}
		 * @since 0.65
		 */
		getSelection: function() {
			return ctx.selection();
		},
		
		/**
		 * Returns current editor's file path
		 * @return {String}
		 * @since 0.65 
		 */
		getFilePath: function() {
			if ('filePath' in ctx)
				return ctx.filePath();

			return '';
		}
	};
})();

function objcRunAction(name) {
	return zen_coding.require('actions').run(String(name), objcZenEditor);
}

function objcSetContext(ctx) {
	objcZenEditor.setContext(ctx);
}

function objcProcessTextBeforePasteWithDelegate(text, delegate) {
	var _ = zen_coding.require('_');
	var escapeFn = function(ch){
		return delegate.handleEscape(ch);
	};
	var tabstopFn = function(ix, num, placeholder) {
		return delegate.handleTabstopAt_withNumber_andPlaceholder(ix, num, placeholder);
	};

	return zen_coding.require('editorUtils').processTextBeforePaste(String(text), escapeFn, tabstopFn);
}