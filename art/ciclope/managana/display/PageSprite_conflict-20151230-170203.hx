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
	private var _holder:Sprite;					// display holder
	private var _mask:Shape;					// display mask for pages
	#if html5
		private var _click:Shape;				// background for click handling
	#end
	
	// GETTERS/SETTERS
	
	private var _other(get, null):Int;			// media sprite not shown at the moment
	
	/**
	 * Currenlty loaded file url.
	 */
	public var url(get, null):String;

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
		this.
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