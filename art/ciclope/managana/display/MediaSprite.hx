package art.ciclope.managana.display;

// CICLOPE CLASSES
import art.ciclope.managana.display.GraphicSprite;
import art.ciclope.managana.display.AudioSprite;
import art.ciclope.managana.display.TextSprite;
import art.ciclope.managana.display.VideoSprite;
import art.ciclope.managana.display.BaseSprite;
import art.ciclope.managana.util.MediaInfo;
import art.ciclope.managana.event.SpriteEvent;

// OPENFL PACKAGES
import openfl.display.Sprite;

/**
 * <b>CICLOPE MANAGANA - www.ciclope.com.br / www.managana.org</b><br>
 * <b>License:</b> GNU LGPL version 3<br><br>
 * MediaSprite provides a single class to handle the download and the display of all media types supported by Managana.
 * @author Lucas Junqueira <lucas@ciclope.art.br>
 */
class MediaSprite extends Sprite
{
	
	// DISPLAY SPRITES
	
	private var _grSprite:GraphicSprite;							// graphics display
	private var _vdSprite:VideoSprite;								// video display
	private var _auSprite:AudioSprite;								// audio playback
	private var _txSprite:TextSprite;								// text display
	private var _sprites:Map<String, BaseSprite>;					// display holder
	
	// PRIVATE VALUES
	
	private var _currentType:String = MediaInfo.TYPE_UNKNOWN;		// current media type on display
	private var _tryType:String = '';								// media type attempting to download
	
	// GETTERS/SETTERS
	
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
	
	/**
	 * Smoothed display?
	 */
	public var smoothing(get, set):Bool;
	
	/**
	 * Content original width.
	 */
	public var oWidth(get, null):Float;
	
	/**
	 * Content original height.
	 */
	public var oHeight(get, null):Float;
	
	/**
	 * MediaSprite constructor.
	 * @param	w	the original width
	 * @param	h	the original height
	 */
	public function new(w:Float = 160, h:Float = 90) 
	{
		super();
		
		// prepare display sprites
		
		this._grSprite = new GraphicSprite();
		this._grSprite.width = w;
		this._grSprite.height = h;
		this._grSprite.addEventListener(SpriteEvent.CONTENT_LOADED, onContentLoaded);
		this._grSprite.addEventListener(SpriteEvent.CONTENT_LOAD_ERROR, onContentLoadError);
		this._grSprite.addEventListener(SpriteEvent.CONTENT_LOOP, onContentLoop);
		this._grSprite.addEventListener(SpriteEvent.CONTENT_END, onContentEnd);
		
		this._vdSprite = new VideoSprite();
		this._vdSprite.width = w;
		this._vdSprite.height = h;
		this._vdSprite.addEventListener(SpriteEvent.CONTENT_LOADED, onContentLoaded);
		this._vdSprite.addEventListener(SpriteEvent.CONTENT_LOAD_ERROR, onContentLoadError);
		this._vdSprite.addEventListener(SpriteEvent.CONTENT_LOOP, onContentLoop);
		this._vdSprite.addEventListener(SpriteEvent.CONTENT_END, onContentEnd);
		
		this._auSprite = new AudioSprite();
		this._auSprite.width = w;
		this._auSprite.height = h;
		this._auSprite.addEventListener(SpriteEvent.CONTENT_LOADED, onContentLoaded);
		this._auSprite.addEventListener(SpriteEvent.CONTENT_LOAD_ERROR, onContentLoadError);
		this._auSprite.addEventListener(SpriteEvent.CONTENT_LOOP, onContentLoop);
		this._auSprite.addEventListener(SpriteEvent.CONTENT_END, onContentEnd);
		
		this._txSprite = new TextSprite();
		this._txSprite.width = w;
		this._txSprite.height = h;
		this._txSprite.addEventListener(SpriteEvent.CONTENT_LOADED, onContentLoaded);
		this._txSprite.addEventListener(SpriteEvent.CONTENT_LOAD_ERROR, onContentLoadError);
		this._txSprite.addEventListener(SpriteEvent.CONTENT_LOOP, onContentLoop);
		this._txSprite.addEventListener(SpriteEvent.CONTENT_END, onContentEnd);
		
		// create a table of display sprites for easy reference
		
		this._sprites = new Map<String, BaseSprite>();
		this._sprites.set(MediaInfo.TYPE_GRAPHIC, this._grSprite);
		this._sprites.set(MediaInfo.TYPE_AUDIO, this._auSprite);
		this._sprites.set(MediaInfo.TYPE_TEXT, this._txSprite);
		this._sprites.set(MediaInfo.TYPE_VIDEO, this._vdSprite);
		
		// set initial smoothing
		this.smoothing = true;
		
	}
	
	// GETTERS/SETTERS
	
	/**
	 * Current media type on display.
	 */
	public function get_mediaType():String
	{
		return (this._currentType);
	}
	
	/**
	 * Start the media playback as soon as it is loaded?
	 */
	public function get_playOnLoad():Bool
	{
		return (this._grSprite.playOnLoad);
	}
	public function set_playOnLoad(value:Bool):Bool
	{
		this._grSprite.playOnLoad = value;
		this._auSprite.playOnLoad = value;
		this._txSprite.playOnLoad = value;
		this._vdSprite.playOnLoad = value;
		return (value);
	}
	
	/**
	 * Text display mode.
	 */
	public function get_textDisplay():String
	{
		return (this._txSprite.textDisplay);
	}
	public function set_textDisplay(value:String):String
	{
		return (this._txSprite.textDisplay = value);
	}
	
	/**
	 * Text content alignment.
	 */
	public function get_textAlign():String
	{
		return (this._txSprite.textAlign);
	}
	public function set_textAlign(value:String):String
	{
		return (this._txSprite.textAlign = value);
	}
	
	/**
	 * Text font name.
	 */
	public function get_fontName():String
	{
		return (this._txSprite.fontName);
	}
	public function set_fontName(value:String):String
	{
		return (this._txSprite.fontName = value);
	}
	
	/**
	 * Text font size.
	 */
	public function get_fontSize():Int
	{
		return (this._txSprite.fontSize);
	}
	public function set_fontSize(value:Int):Int
	{
		return (this._txSprite.fontSize = value);
	}
	
	/**
	 * Text font color.
	 */
	public function get_fontColor():Int
	{
		return (this._txSprite.fontColor);
	}
	public function set_fontColor(value:Int):Int
	{
		return (this._txSprite.fontColor = value);
	}
	
	/**
	 * Is text bold?
	 */
	public function get_fontBold():Bool
	{
		return (this._txSprite.fontBold);
	}
	public function set_fontBold(value:Bool):Bool
	{
		return (this._txSprite.fontBold = value);
	}
	
	/**
	 * Is text italic?
	 */
	public function get_fontItalic():Bool
	{
		return (this._txSprite.fontItalic);
	}
	public function set_fontItalic(value:Bool):Bool
	{
		return (this._txSprite.fontItalic = value);
	}
	
	/**
	 * Text leading.
	 */
	public function get_leading():Int
	{
		return (this._txSprite.leading);
	}
	public function set_leading(value:Int):Int
	{
		return (this._txSprite.leading = value);
	}
	
	/**
	 * Space between chars.
	 */
	public function get_letterSpacing():Float
	{
		return (this._txSprite.letterSpacing);
	}
	public function set_letterSpacing(value:Float):Float
	{
		return (this._txSprite.letterSpacing = value);
	}
	
	/**
	 * Maximum number of chars of plain text to display (<= 0 for no limit, does not affect HTML).
	 */
	public function get_maxChars():Int
	{
		return (this._txSprite.maxChars);
	}
	public function set_maxChars(value:Int):Int
	{
		return (this._txSprite.maxChars = value);
	}
	
	/**
	 * Currently loaded media total time.
	 */
	public function get_totalTime():Int
	{
		if (this._currentType != MediaInfo.TYPE_UNKNOWN) {
			return (this._sprites.get(this._currentType).totalTime);
		} else {
			return (0);
		}
	}
	
	/**
	 * Smoothed display?
	 */
	public function get_smoothing():Bool
	{
		return (this._vdSprite.smoothing);
	}
	public function set_smoothing(value:Bool):Bool
	{
		this._grSprite.smoothing = value;
		this._vdSprite.smoothing = value;
		return (true);
	}
	
	/**
	 * Content original width.
	 */
	public function get_oWidth():Float
	{
		if (this._currentType != MediaInfo.TYPE_UNKNOWN) {
			return (this._sprites.get(this._currentType).oWidth);
		} else {
			return (0);
		}
	}
	
	/**
	 * Content original height.
	 */
	public function get_oHeight():Float
	{
		if (this._currentType != MediaInfo.TYPE_UNKNOWN) {
			return (this._sprites.get(this._currentType).oHeight);
		} else {
			return (0);
		}
	}
	
	/**
	 * Currently loaded media time.
	 */
	public function get_time():Int
	{
		if (this._currentType != MediaInfo.TYPE_UNKNOWN) {
			return (this._sprites.get(this._currentType).time);
		} else {
			return (0);
		}
	}
	
	/**
	 * Currently loaded media url.
	 */
	public function get_url():String
	{
		if (this._currentType != MediaInfo.TYPE_UNKNOWN) {
			return (this._sprites.get(this._currentType).url);
		} else {
			return ('');
		}
	}
	
	/**
	 * Currently loaded media playback state.
	 */
	public function get_state():String
	{
		if (this._currentType != MediaInfo.TYPE_UNKNOWN) {
			return (this._sprites.get(this._currentType).state);
		} else {
			return (MediaInfo.STATE_UNKNOWN);
		}
	}
	
	/**
	 * Currently loading a content?
	 */
	public function get_loading():Bool
	{
		if (this._tryType != '') {
			return (this._sprites.get(this._tryType).loading);
		} else {
			return (false);
		}
	}
	
	/**
	 * Display width.
	 */
	#if flash
		@:getter(width)
		public function get_width():Float
		{
			return (this._grSprite.width);
		}
		@:setter(width)
		public function set_width(value:Float):Void
		{
			this._grSprite.width = value;
			this._auSprite.width = value;
			this._vdSprite.width = value;
			this._txSprite.width = value;
		}
	#else
		override public function get_width():Float
		{
			return (this._grSprite.width);
		}
		override public function set_width(value:Float):Float
		{
			this._grSprite.width = value;
			this._auSprite.width = value;
			this._vdSprite.width = value;
			this._txSprite.width = value;
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
			return (this._grSprite.height);
		}
		@:setter(height)
		public function set_height(value:Float):Void
		{
			this._grSprite.height = value;
			this._auSprite.height = value;
			this._vdSprite.height = value;
			this._txSprite.height = value;
		}
	#else
		override public function get_height():Float
		{
			return (this._grSprite.height);
		}
		override public function set_height(value:Float):Float
		{
			this._grSprite.width = height;
			this._auSprite.width = height;
			this._vdSprite.width = height;
			this._txSprite.width = height;
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
		if (this._grSprite.load(url)) {
			this._tryType = MediaInfo.TYPE_GRAPHIC;
			return (true);
		} else {
			return (false);
		}
	}
	
	/**
	 * Load a sound into the media sprite.
	 * @param	url	the sound file url
	 * @return	true if the loading was started, false if it can't be loaded
	 */
	public function loadSound(url:String):Bool
	{
		if (this._auSprite.load(url)) {
			this._tryType = MediaInfo.TYPE_AUDIO;
			return (true);
		} else {
			return (false);
		}
	}
	
	/**
	 * Load a plain text into the media sprite.
	 * @param	url	the plain text file url
	 * @return	true if the loading was started, false if it can't be loaded
	 */
	public function loadText(url:String):Bool
	{
		if (this._txSprite.load(url)) {
			this._tryType = MediaInfo.TYPE_TEXT;
			return (true);
		} else {
			return (false);
		}
	}
	
	/**
	 * Load a HTML text into the media sprite.
	 * @param	url	the HTML text file url
	 * @return	true if the loading was started, false if it can't be loaded
	 */
	public function loadHTMLText(url:String):Bool
	{
		if (this._txSprite.loadHTML(url)) {
			this._tryType = MediaInfo.TYPE_TEXT;
			return (true);
		} else {
			return (false);
		}
	}
	
	/**
	 * Load a video into the media sprite.
	 * @param	url	the video file url
	 * @return	true if the loading was started, false if it can't be loaded
	 */
	public function loadVideo(url:String):Bool
	{
		if (this._vdSprite.load(url)) {
			this._tryType = MediaInfo.TYPE_VIDEO;
			return (true);
		} else {
			return (false);
		}
	}
	
	/**
	 * Set the media sprite content to a plain text.
	 * @param	txt	the plain text to show
	 */
	public function setText(txt:String):Void
	{
		this._tryType = MediaInfo.TYPE_TEXT;
		this._txSprite.setText(txt);
	}
	
	/**
	 * Set the media sprite content to a HTML text.
	 * @param	txt	the HTML text to show
	 */
	public function setHTMLText(txt:String):Void
	{
		this._tryType = MediaInfo.TYPE_TEXT;
		this._txSprite.setHTMLText(txt);
	}
	
	/**
	 * Start media playback.
	 * @param	time	the starting time in seconds (-1 for current time)
	 */
	public function play(time:Int = -1):Void
	{
		if (this._currentType != MediaInfo.TYPE_UNKNOWN) {
			this._sprites.get(this._currentType).play(time);
		}
	}
	
	/**
	 * Pause media playback.
	 */
	public function pause():Void
	{
		if (this._currentType != MediaInfo.TYPE_UNKNOWN) {
			this._sprites.get(this._currentType).pause();
		}
	}
	
	/**
	 * Set media playback time position.
	 * @param	to	the time (seconds) to go to
	 */
	public function seek(to:Int):Void
	{
		if (this._currentType != MediaInfo.TYPE_UNKNOWN) {
			this._sprites.get(this._currentType).seek(to);
		}
	}
	
	/**
	 * Stop media playback.
	 */
	public function stop():Void
	{
		if (this._currentType != MediaInfo.TYPE_UNKNOWN) {
			this._sprites.get(this._currentType).stop();
		}
	}
	
	/**
	 * General system update (must be called every second).
	 * @return	the current media playback time
	 */
	public function update():Int
	{
		this._grSprite.update();
		this._auSprite.update();
		this._txSprite.update();
		this._vdSprite.update();
		if (this._currentType != MediaInfo.STATE_UNKNOWN) {
			return(this._sprites.get(this._currentType).time);
		} else {
			return (0);
		}
	}
	
	/**
	 * Release resources used by the object.
	 */
	public function dispose():Void
	{
		this.removeChildren();
		for (key in this._sprites.keys()) this._sprites.remove(key);
		this._sprites = null;
		this._grSprite.removeEventListener(SpriteEvent.CONTENT_LOADED, onContentLoaded);
		this._grSprite.removeEventListener(SpriteEvent.CONTENT_LOAD_ERROR, onContentLoadError);
		this._grSprite.removeEventListener(SpriteEvent.CONTENT_LOOP, onContentLoop);
		this._grSprite.removeEventListener(SpriteEvent.CONTENT_END, onContentEnd);
		this._grSprite.dispose();
		this._grSprite = null;
		this._auSprite.removeEventListener(SpriteEvent.CONTENT_LOADED, onContentLoaded);
		this._auSprite.removeEventListener(SpriteEvent.CONTENT_LOAD_ERROR, onContentLoadError);
		this._auSprite.removeEventListener(SpriteEvent.CONTENT_LOOP, onContentLoop);
		this._auSprite.removeEventListener(SpriteEvent.CONTENT_END, onContentEnd);
		this._auSprite.dispose();
		this._auSprite = null;
		this._txSprite.removeEventListener(SpriteEvent.CONTENT_LOADED, onContentLoaded);
		this._txSprite.removeEventListener(SpriteEvent.CONTENT_LOAD_ERROR, onContentLoadError);
		this._txSprite.removeEventListener(SpriteEvent.CONTENT_LOOP, onContentLoop);
		this._txSprite.removeEventListener(SpriteEvent.CONTENT_END, onContentEnd);
		this._txSprite.dispose();
		this._txSprite = null;
		this._vdSprite.removeEventListener(SpriteEvent.CONTENT_LOADED, onContentLoaded);
		this._vdSprite.removeEventListener(SpriteEvent.CONTENT_LOAD_ERROR, onContentLoadError);
		this._vdSprite.removeEventListener(SpriteEvent.CONTENT_LOOP, onContentLoop);
		this._vdSprite.removeEventListener(SpriteEvent.CONTENT_END, onContentEnd);
		this._vdSprite.dispose();
		this._vdSprite = null;
		this._currentType = null;
	}
	
	// PRIVATE METHODS
	
	/**
	 * A new media content was just loaded.
	 */
	private function onContentLoaded(evt:SpriteEvent):Void
	{
		// set current media type
		this._currentType = this._tryType;
		this._tryType = '';
		// remove any previous displays and pause them
		this.removeChildren();
		for (key in this._sprites.keys()) {
			if (key != this._currentType) this._sprites.get(key).pause();
		}
		// adjust smoothing for loaded graphic
		if (this._currentType == MediaInfo.TYPE_GRAPHIC) {
			this._grSprite.smoothing = this.smoothing;
		}
		// add current display
		this.addChild(this._sprites.get(this._currentType));
		// warn listeners
		this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOADED, this._currentType));
	}
	
	/**
	 * A media content failed to load.
	 */
	private function onContentLoadError(evt:SpriteEvent):Void
	{
		this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOAD_ERROR, this._tryType));
		this._tryType = '';
	}
	
	/**
	 * A media content playback just looped.
	 */
	private function onContentLoop(evt:SpriteEvent):Void
	{
		this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOOP, this._currentType));
	}
	
	/**
	 * A media content playback just ended.
	 */
	private function onContentEnd(evt:SpriteEvent):Void
	{
		this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_END, this._currentType));
	}
	
}