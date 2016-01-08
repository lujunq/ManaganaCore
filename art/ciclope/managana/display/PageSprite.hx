package art.ciclope.managana.display;

// CICLOPE CLASSES
import art.ciclope.managana.display.MediaSprite;
import art.ciclope.managana.event.SpriteEvent;
import openfl.geom.ColorTransform;

// OPENFL PACKAGES
import openfl.display.Shape;
import openfl.display.Sprite;

// ACTUATE
import motion.Actuate;

/**
 * <b>CICLOPE MANAGANA - www.ciclope.com.br / www.managana.org</b><br>
 * <b>License:</b> GNU LGPL version 3<br><br>
 * PageSprite provides a fancy way to load all Managana-supported media files with animated transitions.
 * The class also sets the object rotation pivot to the center of the display.
 * @author Lucas Junqueira <lucas@ciclope.art.br>
 */
class PageSprite extends Sprite
{
	// TRANSITION TYPES
	
	/**
	 * Media load transition: none.
	 */
	inline public static var TRANSITION_NONE = 'TRANSITION_NONE';
	
	/**
	 * Media load transition: from right.
	 */
	inline public static var TRANSITION_FROMRIGHT = 'TRANSITION_FROMRIGHT';
	
	/**
	 * Media load transition: from left.
	 */
	inline public static var TRANSITION_FROMLEFT = 'TRANSITION_FROMLEFT';
	
	/**
	 * Media load transition: from top.
	 */
	inline public static var TRANSITION_FROMTOP = 'TRANSITION_FROMTOP';
	
	/**
	 * Media load transition: from bottom.
	 */
	inline public static var TRANSITION_FROMBOTTOM = 'TRANSITION_FROMBOTTOM';
	
	// SPRITE PAGES
	
	private var _page0:MediaSprite;				// one media page
	private var _page1:MediaSprite;				// one media page
	private var _pages:Array<MediaSprite>;		// media pages holder
	private var _sprholder:Sprite;				// media page sprite holder
	
	// PRIVATE VALUES
	
	private var _current:Int = 0;				// current displayed page
	private var _mask:Shape;					// display mask for pages
	private var _tweening:Bool = false;			// playing media change animation?
	private var _setX:Float = 0;				// display X position
	private var _setY:Float = 0;				// display Y position
	private var _ctransform:ColorTransform;		// color transformation
	#if html5
		private var _click:Shape;				// background for click handling
	#end
	
	// PUBLIC VALUES
	
	/**
	 * Media load transition type.
	 */
	public var transition:String = PageSprite.TRANSITION_NONE;
	
	/**
	 * Media transition time.
	 */
	public var transitionTime:Float = 1;
	
	// GETTERS/SETTERS
	
	#if !flash
		private var _other(get, null):Int;			// media sprite not shown at the moment
		
		/**
		 * Current media type on display.
		 */
		public var mediaType(get, never):String;
		
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
		public var totalTime(get, never):Int;
		
		/**
		 * Currently loaded media time.
		 */
		public var time(get, never):Int;
		
		/**
		 * Currently loaded media url.
		 */
		public var url(get, never):String;
		
		/**
		 * Currently loaded media playback state.
		 */
		public var state(get, never):String;
		
		/**
		 * Currently loading a content?
		 */
		public var loading(get, never):Bool;
		
		/**
		 * Smoothed display?
		 */
		public var smoothing(get, set):Bool;
		
		/**
		 * Content original width.
		 */
		public var oWidth(get, never):Float;
		
		/**
		 * Content original height.
		 */
		public var oHeight(get, never):Float;
	#end

	/**
	 * PageSprite constructor.
	 * @param	w	the original width
	 * @param	h	the original height
	 */
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
		
		this._sprholder = new Sprite();
		this.addChild(this._sprholder);
		
		this._page0 = new MediaSprite(w, h);
		this._page1 = new MediaSprite(w, h);
		this._pages = new Array<MediaSprite>();
		this._pages.push(this._page0);
		this._pages.push(this._page1);
		
		this._sprholder.addChild(this._page0);
		this._page1.visible = false;
		this._sprholder.addChild(this._page1);
		
		this._mask = new Shape();
		this._mask.graphics.beginFill(0xFF9900);
		this._mask.graphics.drawRect(0, 0, w, h);
		this._mask.graphics.endFill();
		this.addChild(this._mask);
		
		this._sprholder.mask = this._mask;
		
		this._page0.addEventListener(SpriteEvent.CONTENT_LOADED, onContentLoaded);
		this._page0.addEventListener(SpriteEvent.CONTENT_LOAD_ERROR, onContentLoadError);
		this._page0.addEventListener(SpriteEvent.CONTENT_LOOP, onContentLoop);
		this._page0.addEventListener(SpriteEvent.CONTENT_END, onContentEnd);
		
		this._page1.addEventListener(SpriteEvent.CONTENT_LOADED, onContentLoaded);
		this._page1.addEventListener(SpriteEvent.CONTENT_LOAD_ERROR, onContentLoadError);
		this._page1.addEventListener(SpriteEvent.CONTENT_LOOP, onContentLoop);
		this._page1.addEventListener(SpriteEvent.CONTENT_END, onContentEnd);
		
		// place sprites
		
		this._sprholder.x = this._mask.x = -w / 2;
		this._sprholder.y = this._mask.y = -h / 2;
		#if html5
			this._click.x = this._mask.x;
			this._click.y = this._mask.y;
		#end
		
		// transformations
		
		this._ctransform = new ColorTransform();
		
	}
	
	// GETTERS/SETTERS
	
	/**
	 * The media sprite index not shown at the moment.
	 */
	@:getter(_other)
	private function get__other():Int
	{
		if (this._current == 0) return (1);
			else return (0);
	}
	
	/**
	 * Currenlty loaded file url.
	 */
	@:getter(url)
	public function get_url():String
	{
		return (this._pages[this._current].url);
	}
	
	/**
	 * Current media type on display.
	 */
	@:getter(mediaType)
	public function get_mediaType():String
	{
		return (this._pages[this._current].mediaType);
	}
	
	/**
	 * Start the media playback as soon as it is loaded?
	 */
	@:getter(playOnLoad)
	public function get_playOnLoad():Bool
	{
		return (this._pages[this._current].playOnLoad);
	}
	@:setter(playOnLoad)
	public function set_playOnLoad(value:Bool):Bool
	{
		this._page0.playOnLoad = value;
		this._page1.playOnLoad = value;
		return (value);
	}
	
	/**
	 * Text display mode.
	 */
	@:getter(textDisplay)
	public function get_textDisplay():String
	{
		return (this._pages[this._current].textDisplay);
	}
	@:setter(textDisplay)
	public function set_textDisplay(value:String):String
	{
		this._page0.textDisplay = value;
		this._page1.textDisplay = value;
		return (value);
	}
	
	/**
	 * Text content alignment.
	 */
	@:getter(textAlign)
	public function get_textAlign():String
	{
		return (this._pages[this._current].textAlign);
	}
	@:setter(textAlign)
	public function set_textAlign(value:String):String
	{
		this._page0.textAlign = value;
		this._page1.textAlign = value;
		return (value);
	}
	
	/**
	 * Text font name.
	 */
	@:getter(fontName)
	public function get_fontName():String
	{
		return (this._pages[this._current].fontName);
	}
	@:setter(fontName)
	public function set_fontName(value:String):String
	{
		this._page0.fontName = value;
		this._page1.fontName = value;
		return (value);
	}
	
	/**
	 * Text font size.
	 */
	@:getter(fontSize)
	public function get_fontSize():Int
	{
		return (this._pages[this._current].fontSize);
	}
	@:setter(fontSize)
	public function set_fontSize(value:Int):Int
	{
		this._page0.fontSize = value;
		this._page1.fontSize = value;
		return (value);
	}
	
	/**
	 * Text font color.
	 */
	@:getter(fontColor)
	public function get_fontColor():Int
	{
		return (this._pages[this._current].fontColor);
	}
	@:setter(fontColor)
	public function set_fontColor(value:Int):Int
	{
		this._page0.fontColor = value;
		this._page1.fontColor = value;
		return (value);
	}
	
	/**
	 * Is text bold?
	 */
	@:getter(fontBold)
	public function get_fontBold():Bool
	{
		return (this._pages[this._current].fontBold);
	}
	@:setter(fontBold)
	public function set_fontBold(value:Bool):Bool
	{
		this._page0.fontBold = value;
		this._page1.fontBold = value;
		return (value);
	}
	
	/**
	 * Is text italic?
	 */
	@:getter(fontItalic)
	public function get_fontItalic():Bool
	{
		return (this._pages[this._current].fontItalic);
	}
	@:setter(fontItalic)
	public function set_fontItalic(value:Bool):Bool
	{
		this._page0.fontItalic = value;
		this._page1.fontItalic = value;
		return (value);
	}
	
	/**
	 * Text leading.
	 */
	@:getter(leading)
	public function get_leading():Int
	{
		return (this._pages[this._current].leading);
	}
	@:setter(leading)
	public function set_leading(value:Int):Int
	{
		this._page0.leading = value;
		this._page1.leading = value;
		return (value);
	}
	
	/**
	 * Space between chars.
	 */
	@:getter(letterSpacing)
	public function get_letterSpacing():Float
	{
		return (this._pages[this._current].letterSpacing);
	}
	@:setter(letterSpacing)
	public function set_letterSpacing(value:Float):Float
	{
		this._page0.letterSpacing = value;
		this._page1.letterSpacing = value;
		return (value);
	}
	
	/**
	 * Maximum number of chars of plain text to display (<= 0 for no limit, does not affect HTML).
	 */
	@:getter(maxChars)
	public function get_maxChars():Int
	{
		return (this._pages[this._current].maxChars);
	}
	@:getter(maxChars)
	public function set_maxChars(value:Int):Int
	{
		this._page0.maxChars = value;
		this._page1.maxChars = value;
		return (value);
	}
	
	/**
	 * Currently loaded media total time.
	 */
	@:getter(totalTime)
	public function get_totalTime():Int
	{
		return (this._pages[this._current].totalTime);
	}
	
	/**
	 * Currently loaded media time.
	 */
	@:getter(time)
	public function get_time():Int
	{
		return (this._pages[this._current].time);
	}
	
	/**
	 * Currently loaded media playback state.
	 */
	@:getter(state)
	public function get_state():String
	{
		return (this._pages[this._current].state);
	}
	
	/**
	 * Currently loading a content?
	 */
	@:getter(loading)
	public function get_loading():Bool
	{
		return (this._pages[this._other].loading);
	}
	
	/**
	 * Smoothed display?
	 */
	@:getter(smoothing)
	public function get_smoothing():Bool
	{
		return (this._page0.smoothing);
	}
	@:setter(smoothing)
	public function set_smoothing(value:Bool):Bool
	{
		this._page0.smoothing = value;
		this._page1.smoothing = value;
		return (true);
	}
	
	/**
	 * Content original width.
	 */
	@:getter(oWidth)
	public function get_oWidth():Float
	{
		return (this._pages[this._current].oWidth);
	}
	
	/**
	 * Content original height.
	 */
	@:getter(oHeight)
	public function get_oHeight():Float
	{
		return (this._pages[this._current].oHeight);
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
			this._sprholder.x = this._mask.x = -value / 2;
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
			this._sprholder.x = this._mask.x = -value / 2;
			#if html5
				this._click.width = value;
				this._click.x = this._mask.x;
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
			this._sprholder.y = this._mask.y = -value / 2;
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
			this._sprholder.y = this._mask.y = -value / 2;
			#if html5
				this._click.height = value;
				this._click.y = this._mask.y;
			#end
			return (value);
		}
	#end
	
	/**
	 * Sprite X position.
	 */
	#if flash
		@:getter(x)
		public function get_x():Float
		{
			return (this._setX);
		}
		@:setter(x)
		public function set_x(value:Float):Void
		{
			this._setX = value;
			super.x = value + (this.width / 2);
		}
	#else
		override function get_x():Float
		{
			return (this._setX);
		}
		override function set_x(value:Float):Float
		{
			this._setX = value;
			super.x = value + (this.width / 2);
			return (value);
		}
	#end
	
	/**
	 * Sprite Y position.
	 */
	#if flash
		@:getter(y)
		public function get_y():Float
		{
			return (this._setY);
		}
		@:setter(y)
		public function set_y(value:Float):Void
		{
			this._setY = value;
			super.y = value + (this.height / 2);
		}
	#else
		override function get_y():Float
		{
			return (this._setY);
		}
		override function set_y(value:Float):Float
		{
			this._setY = value;
			super.y = value + (this.height / 2);
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
		if (!this._tweening) {
			return (this._pages[this._other].loadGraphic(url));
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
		if (!this._tweening) {
			return (this._pages[this._other].loadSound(url));
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
		if (!this._tweening) {
			return (this._pages[this._other].loadText(url));
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
		if (!this._tweening) {
			return (this._pages[this._other].loadHTMLText(url));
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
		if (!this._tweening) {
			return (this._pages[this._other].loadVideo(url));
		} else {
			return (false);
		}
	}
	
	/**
	 * Set the media sprite content to a plain text.
	 * @param	txt	the plain text to show
	 * @return	true if the text can be set
	 */
	public function setText(txt:String):Bool
	{
		if (!this._tweening) {
			this._pages[this._other].setText(txt);
			return (true);
		} else {
			return (false);
		}
	}
	
	/**
	 * Set the media sprite content to a HTML text.
	 * @param	txt	the HTML text to show
	 * @return	true if the text can be set
	 */
	public function setHTMLText(txt:String):Bool
	{
		if (!this._tweening) {
			this._pages[this._other].setHTMLText(txt);
			return (true);
		} else {
			return (false);
		}
	}
	
	/**
	 * Start media playback.
	 * @param	time	the starting time in seconds (-1 for current time)
	 */
	public function play(time:Int = -1):Void
	{
		if (!this._tweening) this._pages[this._current].play(time);
	}
	
	/**
	 * Pause media playback.
	 */
	public function pause():Void
	{
		if (!this._tweening) this._pages[this._current].pause();
	}
	
	/**
	 * Set media playback time position.
	 * @param	to	the time (seconds) to go to
	 */
	public function seek(to:Int):Void
	{
		if (!this._tweening) this._pages[this._current].seek(to);
	}
	
	/**
	 * Stop media playback.
	 */
	public function stop():Void
	{
		if (!this._tweening) this._pages[this._current].stop();
	}
	
	/**
	 * General system update (must be called every second).
	 * @return	the current media playback time
	 */
	public function update():Int
	{
		if (!this._tweening)  {
			return (this._pages[this._current].update());
		} else {
			return (0);
		}
	}
	
	/**
	 * Set the red color offset.
	 * @param	to	the new color offset
	 */
	public function setRed(to:Float):Void
	{
		if ((to >= 0) && (to <= 255)) {
			this._ctransform.redOffset = to;
			#if flash
				this.transform.colorTransform = this._ctransform;
			#else
				this._page0.setRed(to);
				this._page1.setRed(to);
			#end
		}
	}
	
	/**
	 * Set the green color offset.
	 * @param	to	the new color offset
	 */
	public function setGreen(to:Float):Void
	{
		if ((to >= 0) && (to <= 255)) {
			this._ctransform.greenOffset = to;
			#if flash
				this.transform.colorTransform = this._ctransform;
			#else
				this._page0.setGreen(to);
				this._page1.setGreen(to);
			#end
		}
	}
	
	/**
	 * Set the blue color offset.
	 * @param	to	the new color offset
	 */
	public function setBlue(to:Float):Void
	{
		if ((to >= 0) && (to <= 255)) {
			this._ctransform.blueOffset = to;
			#if flash
				this.transform.colorTransform = this._ctransform;
			#else
				this._page0.setBlue(to);
				this._page1.setBlue(to);
			#end
		}
	}
	
	/**
	 * Release resources used by the object.
	 */
	public function dispose():Void
	{
		this.removeChildren();
		this._sprholder.removeChildren();
		this._sprholder = null;
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
		this._ctransform = null;
		#if html5
			this._click.graphics.clear();
			this._click = null;
		#end
	}
	
	// PRIVATE METHODS
	
	/**
	 * A new media content was loaded.
	 */
	private function onContentLoaded(evt:SpriteEvent):Void
	{
		this._pages[this._current].pause();
		this._pages[this._other].pause();
		// start display transition
		this._tweening = true;
		switch (this.transition) {
			case PageSprite.TRANSITION_FROMRIGHT:
				this._pages[this._other].y = 0;
				this._pages[this._other].x = this.width;
				this._pages[this._other].visible = true;
				Actuate.tween(this._pages[this._other], this.transitionTime, { x: 0 } ).onComplete(this.mediaTransitionEnd);
				Actuate.tween(this._pages[this._current], this.transitionTime, { x: -this.width } );
			case PageSprite.TRANSITION_FROMLEFT:
				this._pages[this._other].y = 0;
				this._pages[this._other].x = -this.width;
				this._pages[this._other].visible = true;
				Actuate.tween(this._pages[this._other], this.transitionTime, { x: 0 } ).onComplete(this.mediaTransitionEnd);
				Actuate.tween(this._pages[this._current], this.transitionTime, { x: this.width } );
			case PageSprite.TRANSITION_FROMTOP:
				this._pages[this._other].y = -this.height;
				this._pages[this._other].x = 0;
				this._pages[this._other].visible = true;
				Actuate.tween(this._pages[this._other], this.transitionTime, { y: 0 } ).onComplete(this.mediaTransitionEnd);
				Actuate.tween(this._pages[this._current], this.transitionTime, { y: this.height } );
			case PageSprite.TRANSITION_FROMBOTTOM:
				this._pages[this._other].y = this.height;
				this._pages[this._other].x = 0;
				this._pages[this._other].visible = true;
				Actuate.tween(this._pages[this._other], this.transitionTime, { y: 0 } ).onComplete(this.mediaTransitionEnd);
				Actuate.tween(this._pages[this._current], this.transitionTime, { y: -this.height } );
			default: // no transition set: just change the display
				this._pages[this._other].y = 0;
				this._pages[this._other].x = 0;
				this.mediaTransitionEnd();
		}
	}
	
	/**
	 * The media load transition just finished.
	 */
	private function mediaTransitionEnd():Void
	{
		this._pages[this._current].visible = false;
		this._pages[this._other].visible = true;
		if (this._current == 0) {
			this._current = 1;
		} else {
			this._current = 0;
		}
		this._tweening = false;
		if (this.playOnLoad) this._pages[this._current].play();
		this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOADED, this._pages[this._current].mediaType));
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