package art.ciclope.managana.display;

// CICLOPE CLASSES
import art.ciclope.managana.display.BaseSprite;
import art.ciclope.managana.util.MediaInfo;
import art.ciclope.managana.event.SpriteEvent;

// OPENFL PACKAGES
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.net.URLLoader;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.SecurityErrorEvent;
import openfl.net.URLRequest;

/**
 * <b>CICLOPE MANAGANA - www.ciclope.com.br / www.managana.org</b><br>
 * <b>License:</b> GNU LGPL version 3<br><br>
 * TextSprite extends BaseSprite to enable simple download and display of text files/strings. Plain text and HTML formatting are supported (resukts vary according to the target).
 * @author Lucas Junqueira <lucas@ciclope.art.br>
 */
class TextSprite extends BaseSprite
{
	
	// PUBLIC VALUES
	
	/**
	 * Text display mode.
	 */
	public var textDisplay:String = MediaInfo.TEXTDISPLAY_PARAGRAPH;
	
	/**
	 * Text content alignment.
	 */
	public var textAlign:String = MediaInfo.TEXTALIGN_LEFT;
	
	/**
	 * Text font name.
	 */
	#if flash
		public var fontName:String = '_sans';
	#else
		public var fontName:String = 'Arial';
	#end
	
	/**
	 * Text font size.
	 */
	public var fontSize:Int = 12;
	
	/**
	 * Text font color.
	 */
	public var fontColor:Int = 0xFFFFFF;
	
	/**
	 * Is text bold?
	 */
	public var fontBold:Bool = false;
	
	/**
	 * Is text italic?
	 */
	public var fontItalic:Bool = false;
	
	/**
	 * Text leading.
	 */
	public var leading:Int = 0;
	
	/**
	 * Space between chars.
	 */
	public var letterSpacing:Float = 0;
	
	/**
	 * Maximum number of chars of plain text to display (<= 0 for no limit, does not affect HTML).
	 */
	public var maxChars:Int = 0;
	
	// PRIVATE VALUES
	
	private var _textMode:String = MediaInfo.TEXTMODE_PLAIN;		// text content mode
	private var _text:TextField;									// text display
	private var _textFormat:TextFormat;								// text formatter
	private var _currentText:String = '';							// current text in display
	private var _loader:URLLoader;									// loader for text files
	private var _tryMode:String;									// text mode for tex file download
	
	// GETTERS/SETTERS
	
	#if !flash
		/**
		 * Vertical text scrolling.
		 */
		public var scrollV(get, set):Int;
	#end

	/**
	 * TextSprite constructor.
	 */
	public function new() 
	{
		super();
		this._mediaType = MediaInfo.TYPE_TEXT;
		
		// prepare text display
		this._text = new TextField();
		this._text.width = _width;
		this._text.height = _height;
		this._text.selectable = false;
		this._text.autoSize = TextFieldAutoSize.LEFT;
		this.addChild(this._text);
		// prepare formatter
		this._textFormat = new TextFormat(this.fontName, this.fontSize, this.fontColor, this.fontBold, this.fontItalic);
		this._text.defaultTextFormat = this._textFormat;
		// prepare loader
		this._loader = new URLLoader();
	}
	
	// GETTERS/SETTERES

	/**
	 * Width and height.
	 */
	#if flash
		@:getter(width)
		override public function get_width():Float
		{
			if ((this.textDisplay != MediaInfo.TEXTDISPLAY_ARTISTIC) || (this._textMode == MediaInfo.TEXTMODE_HTML)) {
				return (this._text.width);
			} else {
				return (super.width);
			}
		}
		@:setter(width)
		override public function set_width(value:Float):Void
		{
			this._width = value;
			if ((this.textDisplay != MediaInfo.TEXTDISPLAY_ARTISTIC) || (this._textMode == MediaInfo.TEXTMODE_HTML)) {
				this._text.width = value;
			} else {
				super.width = value;
			}
		}
		@:getter(height)
		override public function get_height():Float
		{
			if ((this.textDisplay != MediaInfo.TEXTDISPLAY_ARTISTIC) || (this._textMode == MediaInfo.TEXTMODE_HTML)) {
				return (this._text.height);
			} else {
				return (super.height);
			}
		}
		@:setter(height)
		override public function set_height(value:Float):Void
		{
			this._height = value;
			if ((this.textDisplay != MediaInfo.TEXTDISPLAY_ARTISTIC) || (this._textMode == MediaInfo.TEXTMODE_HTML)) {
				this._text.height = value;
			} else {
				super.height = value;
			}
		}
	#else
		override public function get_width():Float
		{
			if ((this.textDisplay != MediaInfo.TEXTDISPLAY_ARTISTIC) || (this._textMode == MediaInfo.TEXTMODE_HTML)) {
				return (this._text.width);
			} else {
				return (super.width);
			}
		}
		override public function set_width(value:Float):Float
		{
			this._width = value;
			if ((this.textDisplay != MediaInfo.TEXTDISPLAY_ARTISTIC) || (this._textMode == MediaInfo.TEXTMODE_HTML)) {
				this._text.width = value;
			} else {
				super.width = value;
			}
			return (value);
		}
		override public function get_height():Float
		{
			if ((this.textDisplay != MediaInfo.TEXTDISPLAY_ARTISTIC) || (this._textMode == MediaInfo.TEXTMODE_HTML)) {
				return (this._text.height);
			} else {
				return (super.height);
			}
		}
		override public function set_height(value:Float):Float
		{
			this._height = value;
			if ((this.textDisplay != MediaInfo.TEXTDISPLAY_ARTISTIC) || (this._textMode == MediaInfo.TEXTMODE_HTML)) {
				this._text.height = value;
			} else {
				super.height = value;
			}
			return (value);
		}
	#end
	
	/**
	 * Vertical scroll position.
	 */
	@:getter(scrollV)
	public function get_scrollV():Int
	{
		return (this._text.scrollV);
	}
	@:setter(scrollV)
	public function set_scrollV(value:Int):Int
	{
		if ((this._text.scrollV != value) && (value <= this._text.maxScrollV)) this._text.scrollV = value;
		return (this._text.scrollV);
	}
	
	/**
	 * Content original width.
	 */
	@:getter(oWidth)
	override public function get_oWidth():Float
	{
		if ((this.textDisplay != MediaInfo.TEXTDISPLAY_ARTISTIC) || (this._textMode == MediaInfo.TEXTMODE_HTML)) {
			return (this._text.width);
		} else {
			return (super.width);
		}
	}
	
	/**
	 * Content original height.
	 */
	@:getter(oHeight)
	override public function get_oHeight():Float
	{
		if ((this.textDisplay != MediaInfo.TEXTDISPLAY_ARTISTIC) || (this._textMode == MediaInfo.TEXTMODE_HTML)) {
			return (this._text.height);
		} else {
			return (super.height);
		}
	}
	
	// PUBLIC METHODS
	
	/**
	 * Set a new text content.
	 * @param	txt	the text to display
	 */
	public function setText(txt:String):Void
	{
		// remove windows line breaks
		txt = txt.split("\r").join("");
		this._currentText = txt;
		// maximum number of chars?
		if (this.maxChars > 0) {
			if (txt.length > this.maxChars) {
				txt = txt.substr(0, this.maxChars) + '…';
			}
		}
		// adjust display properties
		if (this.textDisplay == MediaInfo.TEXTDISPLAY_ARTISTIC) {
			this._text.wordWrap = false;
			this._text.multiline = false;
			this._textFormat.align = TextFormatAlign.LEFT;
			this._text.autoSize = TextFieldAutoSize.LEFT;
		} else {
			this._text.wordWrap = true;
			this._text.multiline = true;
			this._text.autoSize = TextFieldAutoSize.NONE;
			switch (this.textAlign) {
				case MediaInfo.TEXTALIGN_RIGHT:
					this._textFormat.align = TextFormatAlign.RIGHT;
				case MediaInfo.TEXTALIGN_CENTER:
					this._textFormat.align = TextFormatAlign.CENTER;
				case MediaInfo.TEXTALIGN_JUSTIFY:
					this._textFormat.align = TextFormatAlign.JUSTIFY;
				default:
					this._textFormat.align = TextFormatAlign.LEFT;
			}
		}
		// font properties
		this._textFormat.font = this.fontName;
		this._textFormat.size = this.fontSize;
		this._textFormat.color = this.fontColor;
		this._textFormat.bold = this.fontBold;
		this._textFormat.italic = this.fontItalic;
		this._textFormat.leading = this.leading;
		this._textFormat.letterSpacing = this.letterSpacing;
		// set text
		this._textMode = MediaInfo.TEXTMODE_PLAIN;
		this._text.defaultTextFormat = this._textFormat;
		this._text.embedFonts = true;
		this._text.text = txt;
		
		this._url = null;
		
		// resize
		this.width = this._width;
		this.height = this._height;
		
		// warn listeners
		this._time = 0;
		this._loading = false;
		this._loaded = true;
		if (this.playOnLoad) {
			this._state = MediaInfo.STATE_PLAY;
		} else {
			this._state = MediaInfo.STATE_PAUSE;
		}
		this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOADED, MediaInfo.TYPE_TEXT));
	}
	
	/**
	 * Set a new html text content.
	 * @param	txt	the text to display
	 */
	public function setHTMLText(txt:String):Void
	{
		// html entities fix
		if ((txt.indexOf('<body>') < 0) && (txt.indexOf('<TEXTFORMAT') < 0)) txt = '<body>' + txt + '</body>';
		txt = txt.split("<br>").join("<br />");
		#if html5
			#if !dom
				// fox for HTML5 canvas
				txt = txt.split("<br />").join("\n");
				txt = txt.split("</p>").join("\n");
			#end
		#end
		this._currentText = txt;
				
		this._text.wordWrap = true;
		this._text.multiline = true;
		this._textFormat.align = TextFormatAlign.LEFT;
		this._textMode = MediaInfo.TEXTMODE_HTML;
		this._text.embedFonts = false;
		this._text.htmlText = txt;
		
		this._url = null;
		
		// resize
		this.width = this._width;
		this.height = this._height;
		
		// warn listeners
		this._time = 0;
		this._loading = false;
		this._loaded = true;
		if (this.playOnLoad) {
			this._state = MediaInfo.STATE_PLAY;
		} else {
			this._state = MediaInfo.STATE_PAUSE;
		}
		this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOADED, MediaInfo.TYPE_TEXT));
	}
	
	/**
	 * Refresh current text display.
	 */
	public function refresh():Void
	{
		var holdURL:String = this._url;
		if (this._textMode == MediaInfo.TEXTMODE_HTML) {
			this.setHTMLText(this._currentText);
		} else {
			this.setText(this._currentText);
		}
		this._url = holdURL;
	}
	
	/**
	 * Start loading a new plain text content.
	 * @param	url	the content url to start loading
	 * @return	true if the content downalod can start, false if there is something already downloading
	 */
	override public function load(url:String):Bool
	{
		if (!super.load(url)) {
			// currently loading another content
			return (false);
		} else {
			// start the download
			this._loader.addEventListener(Event.COMPLETE, completeHandler);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			this._loading = true;
			this._tryMode = MediaInfo.TEXTMODE_PLAIN;
			this._loader.load(new URLRequest(this._tryURL));
			return (true);
		}
	}
	
	/**
	 * Start loading a new html text content.
	 * @param	url	the content url to start loading
	 * @return	true if the content downalod can start, false if there is something already downloading
	 */
	public function loadHTML(url:String):Bool
	{
		if (!super.load(url)) {
			// currently loading another content
			return (false);
		} else {
			// start the download
			this._loader.addEventListener(Event.COMPLETE, completeHandler);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			this._loading = true;
			this._tryMode = MediaInfo.TEXTMODE_HTML;
			this._loader.load(new URLRequest(this._tryURL));
			return (true);
		}
	}
	
	/**
	 * Release resources used by the object.
	 */
	override public function dispose():Void
	{
		super.dispose();
		this._text.text = '';
		this._text = null;
		this._textFormat = null;
		this._currentText = null;
		this.fontName = null;
		this.textAlign = null;
		this.textDisplay = null;
		this._textMode = null;
		if (this._loader.hasEventListener(Event.COMPLETE)) {
			try { this._loader.close(); } catch (e:Dynamic) { }
			this._loader.removeEventListener(Event.COMPLETE, completeHandler);
			this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			this._loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		}
		this._loader = null;
		this._tryMode = null;
	}
	
	// PRIVATE METHODS
	
	/**
	 * Text file was just loaded.
	 */
	private function completeHandler(evt:Event):Void
	{
		this._loader.removeEventListener(Event.COMPLETE, completeHandler);
		this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		this._loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		this._url = this._tryURL;
		this._tryURL = '';
		var txt:String = cast(this._loader.data, String);
		if (this._tryMode == MediaInfo.TEXTMODE_HTML) {
			this.setHTMLText(txt);
		} else {
			this.setText(txt);
		}
	}
	
	/**
	 * Error while loading the text content.
	 */
	private function errorHandler(evt:Event):Void
	{
		this._loader.removeEventListener(Event.COMPLETE, completeHandler);
		this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		this._loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		this._tryURL = '';
		this._loading = false;
		this._loaded = false;
		this._state = MediaInfo.STATE_UNKNOWN;
		this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOAD_ERROR, MediaInfo.TYPE_TEXT));
	}
}