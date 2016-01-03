package art.ciclope.managana.display;

// CICLOPE CLASSES
import art.ciclope.managana.event.SpriteEvent;
import art.ciclope.managana.util.MediaInfo;

// OPENFL PACKAGES
import openfl.display.Sprite;

/**
 * <b>CICLOPE MANAGANA - www.ciclope.com.br / www.managana.org</b><br>
 * <b>License:</b> GNU LGPL version 3<br><br>
 * BaseSprite is meant be extended and used as the base for the Managana media display sprites.
 * @author Lucas Junqueira <lucas@ciclope.art.br>
 */
class BaseSprite extends Sprite
{
	
	// PUBLIC VALUES
	
	/**
	 * Start the media playback as soon as it is loaded?
	 */
	public var playOnLoad:Bool = true;
	
	/**
	 * Loop media playback at end?
	 */
	public var loop:Bool = true;
	
	// PRIVATE VALUES
	
	private var _loaded:Bool = false;								// is there a loaded content?
	private var _loading:Bool = false;								// currently loading content?
	private var _state:String = MediaInfo.STATE_UNKNOWN;			// sprite current playback state
	private var _tryURL:String = '';								// current loading url
	private var _url:String = '';									// loaded content url
	private var _time:Int = 0;										// sprite time (seconds)
	private var _totalTime:Int = 10;								// sprite total time (seconds)
	private var _mediaType:String = MediaInfo.TYPE_UNKNOWN;			// sprite media type
	private var _width:Float = 160;									// sprite width
	private var _height:Float = 90;									// sprite height
	
	// GETTERS/SETTERS
	
	/**
	 * Currently loading some content?
	 */
	public var loading(get, null):Bool;
	
	/**
	 * The current media playback state.
	 */
	public var state(get, null):String;
	
	/**
	 * Sprite time.
	 */
	public var time(get, set):Int;
	
	/**
	 * Sprite total time.
	 */
	public var totalTime(get, set):Int;
	
	/**
	 * Loaded content URL.
	 */
	public var url(get, set):String;
	
	/**
	 * Sprite media type.
	 */
	public var mediaType(get, null):String;

	/**
	 * BaseSprite constructor.
	 */
	public function new() 
	{
		super();
	}
	
	// GETTERS/SETTERS
	
	/**
	 * Currently loading some content?
	 */
	public function get_loading():Bool
	{
		return (this._loading);
	}
	
	/**
	 * The current media playback state.
	 */
	public function get_state():String
	{
		return (this._state);
	}
	
	/**
	 * Sprite time.
	 */
	public function get_time():Int
	{
		return (this._time);
	}
	public function set_time(value:Int):Int
	{
		return (this._time = value);
	}
	
	/**
	 * Sprite total time.
	 */
	public function get_totalTime():Int
	{
		return (this._totalTime);
	}
	public function set_totalTime(value:Int):Int
	{
		return (this._totalTime = value);
	}
	
	/**
	 * Loaded content URL.
	 */
	public function get_url():String
	{
		return (this._url);
	}
	public function set_url(value:String):String
	{
		this.load(value);
		return (value);
	}
	
	/**
	 * Sprite media type.
	 */
	public function get_mediaType():String
	{
		return (this._mediaType);
	}
	
	/**
	 * Display width.
	 */
	#if flash
		@:getter(width)
		public function get_width():Float
		{
			return (this._width);
		}
		@:setter(width)
		public function set_width(value:Float):Void
		{
			this._width = value;
		}
	#else
		override public function get_width():Float
		{
			return (this._width);
		}
		override public function set_width(value:Float):Float
		{
			return (this._width = value);
		}
	#end
	
	/**
	 * Display height.
	 */
	#if flash
		@:getter(height)
		public function get_height():Float
		{
			return (this._height);
		}
		@:setter(height)
		public function set_height(value:Float):Void
		{
			this._height = value;
		}
	#else
		override public function get_height():Float
		{
			return (this._height);
		}
		override public function set_height(value:Float):Float
		{
			return (this._height = value);
		}
	#end
	
	// PUBLIC METHODS
	
	/**
	 * Release resources used by the object.
	 */
	public function dispose():Void
	{
		this._tryURL = null;
		this._url = null;
		this._state = null;
		this.removeChildren();
	}
	

	/**
	 * Start loading a new content.
	 * @param	url	the content url to start loading
	 * @return	true if the content downalod can start, false if there is something already downloading
	 */
	public function load(url:String):Bool
	{
		if (this._loading) {
			return (false);
		} else {
			this._tryURL = url;
			this._time = 0;
			this._loaded = false;
			this._state = MediaInfo.STATE_UNKNOWN;
			return (true);
		}
	}
	
	/**
	 * General system update (must be called every second).
	 * @return	the current media playback time
	 */
	public function update():Int
	{
		if (this._loaded && (this._state == MediaInfo.STATE_PLAY)) this._time++;
		if (this.time >= this.totalTime) {
			if (this.loop) {
				this.play(0);
				this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOOP, this.mediaType));
			} else {
				this.pause();
				this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_END, this.mediaType));
			}
		}
		return (this.time);
	}
	
	/**
	 * Start media playback.
	 * @param	time	the starting time in seconds (-1 for current time)
	 */
	public function play(time:Int = -1):Void
	{
		if (this._loaded) {
			this._state = MediaInfo.STATE_PLAY;
			if (time >= 0) {
				this._time = time;
			}
		}
	}
	
	/**
	 * Pause media playback.
	 */
	public function pause():Void
	{
		if (this._loaded) this._state = MediaInfo.STATE_PAUSE;
	}
	
	/**
	 * Set media playback time position.
	 * @param	to	the time (seconds) to go to
	 */
	public function seek(to:Int):Void
	{
		if (this._loaded) this._time = to;
	}
	
	/**
	 * Stop media playback.
	 */
	public function stop():Void
	{
		if (this._loaded) {
			this.pause();
			this.seek(0);
		}
	}
	
}