var objcZenEditor = (function() {
	var ctx;

	function rangeToObj(range) {
		return  {
			start: range.location,
			end: range.location + range.length
		};
	}
					 
	var autoHandleIndent = true;

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
					 
		setAutoHandleIndent: function(val) {
			autoHandleIndent = val;
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
		getCaretPos: function() {
			return Number(ctx.caretPos());
		},
		
		/**
		 * Set new caret position
		 * @param {Number} pos Caret position
		 */
		setCaretPos: function(pos) {
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
		 * @param {Boolean} [noIndent] Do not auto indent <code>value</code>
		 */
		replaceContent: function(value, start, end, noIndent) {
			var content = this.getContent();
			var caretPos = this.getCaretPos();

			if (_.isUndefined(end)) 
				end = _.isUndefined(start) ? content.length : start;
			if (_.isUndefined(start)) start = 0;
					 
			if (!noIndent && autoHandleIndent) {
				var utils = zen_coding.require('utils');
				var lineRange = utils.findNewlineBounds(String(content), start);
				value = utils.padString(value, utils.getLinePadding(lineRange.substring(content)));
			}
			
			ctx.replaceContentWithValue_from_to_withoutIndentation(value, start, end, !!noIndent);
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

function objcToJSON(data) {
	// do non-strict parsing of JSON data
	try {
		return (new Function('return ' + String(data)))();
	} catch(e) {
		return {};
	}
}

function objcLoadUserSnippets(settingsData, userDefaults) {
	settingsData = objcToJSON(settingsData);
	userDefaults = objcToJSON(userDefaults);
	var utils = zen_coding.require('utils');
	var data = utils.deepMerge({}, settingsData, userDefaults);
	zen_coding.require('resources').setVocabulary(data, 'user');
}

function objcLoadUserPreferences(data) {
	if (data)
		zen_coding.require('preferences').load(objcToJSON(data));
}

function objcLoadSystemSnippets(data) {
	if (data) {
		zen_coding.require('resources').setVocabulary(objcToJSON(data), 'system');
	}
}
