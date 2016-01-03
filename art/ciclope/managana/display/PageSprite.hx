package art.ciclope.managana.display;

import art.ciclope.managana.display.MediaSprite;
import art.ciclope.managana.event.SpriteEvent;
import openfl.display.Shape;

import openfl.display.Sprite;

/**
 * ...
 * @author Lucas S. Junqueira
 */
class PageSprite extends Sprite
{
	
	// SPRITE PAGES
	
	private var _page0:MediaSprite;				// one media page
	private var _page1:MediaSprite;				// one media page
	private var _pages:Array<MediaSprite>;		// media pages holder
	
	// PRIVATE VALUES
	
	private var _current:Int = 0;				// current displayed page
	private var _mask:Shape;					// display mask for pages
	#if html5
		private var _click:Shape;				// background for click handling
	#end
	
	// GETTERS/SETTERS
	
	private var _other(get, null):Int;			// media sprite not shown at the moment
	
	/**
	 * Current media type on display.
	 */
	public var mediaType(get, null):String;
	
	/**
	 * Start the media playback as soon as it is loaded?
	 */
	public var playOnLoad(get, set):Bool;
	
	/**
	 * Text display mode.
	 */
	public var textDisplay(get, set):String;
	
	/**
	 * Text content alignment.
	 */
	public var textAlign(get, set):String;
	
	/**
	 * Text font name.
	 */
	public var fontName(get, set):String;
	
	/**
	 * Text font size.
	 */
	public var fontSize(get, set):Int;
	
	/**
	 * Text font color.
	 */
	public var fontColor(get, set):Int;
	
	/**
	 * Is text bold?
	 */
	public var fontBold(get, set):Bool;
	
	/**
	 * Is text italic?
	 */
	public var fontItalic(get, set):Bool;
	
	/**
	 * Text leading.
	 */
	public var leading(get, set):Int;
	
	/**
	 * Space between chars.
	 */
	public var letterSpacing(get, set):Float;
	
	/**
	 * Maximum number of chars of plain text to display (<= 0 for no limit, does not affect HTML).
	 */
	public var maxChars(get, set):Int;
	
	/**
	 * Currently loaded media total time.
	 */
	public var totalTime(get, null):Int;
	
	/**
	 * Currently loaded media time.
	 */
	public var time(get, null):Int;
	
	/**
	 * Currently loaded media url.
	 */
	public var url(get, null):String;
	
	/**
	 * Currently loaded media playback state.
	 */
	public var state(get, null):String;
	
	/**
	 * Currently loading a content?
	 */
	public var loading(get, null):Bool;

	public function new(w:Float = 160, h:Float = 90) 
	{
		super();
		
		#if html5
			this._click = new Shape();
			this._click.graphics.beginFill(0, 0);
			this._click.graphics.drawRect(0, 0, w, h);
			this._click.graphics.endFill();
			this.addChild(this._click);
		#end
		
		this._page0 = new MediaSprite(w, h);
		this._page1 = new MediaSprite(w, h);
		this._pages = new Array<MediaSprite>();
		this._pages.push(this._page0);
		this._pages.push(this._page1);
		
		this.addChild(this._page0);
		this._page1.visible = false;
		this.addChild(this._page1);
		
		this._mask = new Shape();
		this._mask.graphics.beginFill(0xFF9900);
		this._mask.graphics.drawRect(0, 0, w, h);
		this._mask.graphics.endFill();
		this.addChild(this._mask);
		
		this._page0.mask = this._mask;
		this._page1.mask = this._mask;
		
		this._page0.addEventListener(SpriteEvent.CONTENT_LOADED, onContentLoaded);
		this._page0.addEventListener(SpriteEvent.CONTENT_LOAD_ERROR, onContentLoadError);
		this._page0.addEventListener(SpriteEvent.CONTENT_LOOP, onContentLoop);
		this._page0.addEventListener(SpriteEvent.CONTENT_END, onContentEnd);
		
		this._page1.addEventListener(SpriteEvent.CONTENT_LOADED, onContentLoaded);
		this._page1.addEventListener(SpriteEvent.CONTENT_LOAD_ERROR, onContentLoadError);
		this._page1.addEventListener(SpriteEvent.CONTENT_LOOP, onContentLoop);
		this._page1.addEventListener(SpriteEvent.CONTENT_END, onContentEnd);
		
	}
	
	// GETTERS/SETTERS
	
	private function get__other():Int
	{
		if (this._current == 0) return (1);
			else return (0);
	}
	
	/**
	 * Currenlty loaded file url.
	 */
	public function get_url():String
	{
		return (this._pages[this._current].url);
	}
	
	/**
	 * Current media type on display.
	 */
	public function get_mediaType():String
	{
		return (this._pages[this._current].mediaType);
	}
	
	/**
	 * Start the media playback as soon as it is loaded?
	 */
	public function get_playOnLoad():Bool
	{
		return (this._pages[this._current].playOnLoad);
	}
	public function set_playOnLoad(value:Bool):Bool
	{
		this._page0.playOnLoad = value;
		this._page1.playOnLoad = value;
		return (value);
	}
	
	/**
	 * Text display mode.
	 */
	public function get_textDisplay():String
	{
		return (this._pages[this._current].textDisplay);
	}
	public function set_textDisplay(value:String):String
	{
		this._page0.textDisplay = value;
		this._page1.textDisplay = value;
		return (value);
	}
	
	/**
	 * Text content alignment.
	 */
	public function get_textAlign():String
	{
		return (this._pages[this._current].textAlign);
	}
	public function set_textAlign(value:String):String
	{
		this._page0.textAlign = value;
		this._page1.textAlign = value;
		return (value);
	}
	
	/**
	 * Text font name.
	 */
	public function get_fontName():String
	{
		return (this._pages[this._current].fontName);
	}
	public function set_fontName(value:String):String
	{
		this._page0.fontName = value;
		this._page1.fontName = value;
		return (value);
	}
	
	/**
	 * Text font size.
	 */
	public function get_fontSize():Int
	{
		return (this._pages[this._current].fontSize);
	}
	public function set_fontSize(value:Int):Int
	{
		this._page0.fontSize = value;
		this._page1.fontSize = value;
		return (value);
	}
	
	/**
	 * Text font color.
	 */
	public function get_fontColor():Int
	{
		return (this._pages[this._current].fontColor);
	}
	public function set_fontColor(value:Int):Int
	{
		this._page0.fontColor = value;
		this._page1.fontColor = value;
		return (value);
	}
	
	/**
	 * Is text bold?
	 */
	public function get_fontBold():Bool
	{
		return (this._pages[this._current].fontBold);
	}
	public function set_fontBold(value:Bool):Bool
	{
		this._page0.fontBold = value;
		this._page1.fontBold = value;
		return (value);
	}
	
	/**
	 * Is text italic?
	 */
	public function get_fontItalic():Bool
	{
		return (this._pages[this._current].fontItalic);
	}
	public function set_fontItalic(value:Bool):Bool
	{
		this._page0.fontItalic = value;
		this._page1.fontItalic = value;
		return (value);
	}
	
	/**
	 * Text leading.
	 */
	public function get_leading():Int
	{
		return (this._pages[this._current].leading);
	}
	public function set_leading(value:Int):Int
	{
		this._page0.leading = value;
		this._page1.leading = value;
		return (value);
	}
	
	/**
	 * Space between chars.
	 */
	public function get_letterSpacing():Float
	{
		return (this._pages[this._current].letterSpacing);
	}
	public function set_letterSpacing(value:Float):Float
	{
		this._page0.letterSpacing = value;
		this._page1.letterSpacing = value;
		return (value);
	}
	
	/**
	 * Maximum number of chars of plain text to display (<= 0 for no limit, does not affect HTML).
	 */
	public function get_maxChars():Int
	{
		return (this._pages[this._current].maxChars);
	}
	public function set_maxChars(value:Int):Int
	{
		this._page0.maxChars = value;
		this._page1.maxChars = value;
		return (value);
	}
	
	/**
	 * Currently loaded media total time.
	 */
	public function get_totalTime():Int
	{
		return (this._pages[this._current].totalTime);
	}
	
	/**
	 * Currently loaded media time.
	 */
	public function get_time():Int
	{
		return (this._pages[this._current].time);
	}
	
	/**
	 * Currently loaded media playback state.
	 */
	public function get_state():String
	{
		return (this._pages[this._current].state);
	}
	
	/**
	 * Currently loading a content?
	 */
	public function get_loading():Bool
	{
		return (this._pages[this._other].loading);
	}
	
	/**
	 * Display width.
	 */
	#if flash
		@:getter(width)
		public function get_width():Float
		{
			return (this._mask.width);
		}
		@:setter(width)
		public function set_width(value:Float):Void
		{
			this._mask.width = value;
			this._page0.width = value;
			this._page1.width = value;
		}
	#else
		override public function get_width():Float
		{
			return (this._mask.width);
		}
		override public function set_width(value:Float):Float
		{
			this._mask.width = value;
			this._page0.width = value;
			this._page1.width = value;
			#if html5
				this._click.width = value;
			#end
			return (value);
		}
	#end
	
	/**
	 * Display height.
	 */
	#if flash
		@:getter(height)
		public function get_height():Float
		{
			return (this._mask.height);
		}
		@:setter(height)
		public function set_height(value:Float):Void
		{
			this._mask.height = value;
			this._page0.height = value;
			this._page1.height = value;
		}
	#else
		override public function get_height():Float
		{
			return (this._mask.height);
		}
		override public function set_height(value:Float):Float
		{
			this._mask.height = value;
			this._page0.height = value;
			this._page1.height = value;
			#if html5
				this._click.height = value;
			#end
			return (value);
		}
	#end
	
	// PUBLIC METHODS
	
	/**
	 * Load a picture into the media sprite.
	 * @param	url	the picture file url
	 * @return	true if the loading was started, false if it can't be loaded
	 */
	public function loadGraphic(url:String):Bool
	{
		return (this._pages[this._other].loadGraphic(url));
	}
	
	/**
	 * Load a sound into the media sprite.
	 * @param	url	the sound file url
	 * @return	true if the loading was started, false if it can't be loaded
	 */
	public function loadSound(url:String):Bool
	{
		return (this._pages[this._other].loadSound(url));
	}
	
	/**
	 * Load a plain text into the media sprite.
	 * @param	url	the plain text file url
	 * @return	true if the loading was started, false if it can't be loaded
	 */
	public function loadText(url:String):Bool
	{
		return (this._pages[this._other].loadText(url));
	}
	
	/**
	 * Load a HTML text into the media sprite.
	 * @param	url	the HTML text file url
	 * @return	true if the loading was started, false if it can't be loaded
	 */
	public function loadHTMLText(url:String):Bool
	{
		return (this._pages[this._other].loadHTMLText(url));
	}
	
	/**
	 * Load a video into the media sprite.
	 * @param	url	the video file url
	 * @return	true if the loading was started, false if it can't be loaded
	 */
	public function loadVideo(url:String):Bool
	{
		return (this._pages[this._other].loadVideo(url));
	}
	
	/**
	 * Set the media sprite content to a plain text.
	 * @param	txt	the plain text to show
	 */
	public function setText(txt:String):Void
	{
		this._pages[this._other].setText(txt);
	}
	
	/**
	 * Set the media sprite content to a HTML text.
	 * @param	txt	the HTML text to show
	 */
	public function setHTMLText(txt:String):Void
	{
		this._pages[this._other].setHTMLText(txt);
	}
	
	/**
	 * Start media playback.
	 * @param	time	the starting time in seconds (-1 for current time)
	 */
	public function play(time:Int = -1):Void
	{
		this._pages[this._current].play(time);
	}
	
	/**
	 * Pause media playback.
	 */
	public function pause():Void
	{
		this._pages[this._current].pause();
	}
	
	/**
	 * Set media playback time position.
	 * @param	to	the time (seconds) to go to
	 */
	public function seek(to:Int):Void
	{
		this._pages[this._current].seek(to);
	}
	
	/**
	 * Stop media playback.
	 */
	public function stop():Void
	{
		this._pages[this._current].stop();
	}
	
	/**
	 * General system update (must be called every second).
	 * @return	the current media playback time
	 */
	public function update():Int
	{
		return (this._pages[this._current].update());
	}
	
	/**
	 * Release resources used by the object.
	 */
	public function dispose():Void
	{
		this.removeChildren();
		while (this._pages.length > 0) this._pages.shift();
		this._pages = null;
		this._page0.removeEventListener(SpriteEvent.CONTENT_LOADED, onContentLoaded);
		this._page0.removeEventListener(SpriteEvent.CONTENT_LOAD_ERROR, onContentLoadError);
		this._page0.removeEventListener(SpriteEvent.CONTENT_LOOP, onContentLoop);
		this._page0.removeEventListener(SpriteEvent.CONTENT_END, onContentEnd);
		this._page1.removeEventListener(SpriteEvent.CONTENT_LOADED, onContentLoaded);
		this._page1.removeEventListener(SpriteEvent.CONTENT_LOAD_ERROR, onContentLoadError);
		this._page1.removeEventListener(SpriteEvent.CONTENT_LOOP, onContentLoop);
		this._page1.removeEventListener(SpriteEvent.CONTENT_END, onContentEnd);
		this._page0.mask = null;
		this._page1.mask = null;
		this._page0.dispose();
		this._page1.dispose();
		this._page0 = null;
		this._page1 = null;
		this._mask.graphics.clear();
		this._mask = null;
		#if html5
			this._click.graphics.clear();
			this._click = null;
		#end
	}
	
	// PRIVATE METHODS
	
	/**
	 * Change the current media sprite on display.
	 */
	private function changeCurrent():Void
	{
		this._pages[this._current].visible = false;
		this._pages[this._other].visible = true;
		if (this._current == 0) this._current = 1;
			else this._current = 0;
	}
	
	/**
	 * A new media content was loaded.
	 */
	private function onContentLoaded(evt:SpriteEvent):Void
	{
		this._pages[this._current].pause();
		this._pages[this._other].pause();
		this.changeCurrent();
		if (this.playOnLoad) this._pages[this._current].play();
		this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOADED, evt.mediaType));
	}
	
	/**
	 * The requested media download failed.
	 */
	private function onContentLoadError(evt:SpriteEvent):Void
	{
		this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOAD_ERROR, evt.mediaType));
	}
	
	/**
	 * The loaded content just looped.
	 */
	private function onContentLoop(evt:SpriteEvent):Void
	{
		this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOOP, evt.mediaType));
	}
	
	/**
	 * The loaded content just ended.
	 */
	private function onContentEnd(evt:SpriteEvent):Void
	{
		this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_END, evt.mediaType));
	}
	
}