package art.ciclope.managana.display;

// CICLOPE CLASSES
import art.ciclope.managana.display.BaseSprite;
import art.ciclope.managana.util.MediaInfo;
import art.ciclope.managana.event.SpriteEvent;

// OPENFL PACKAGES
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.SecurityErrorEvent;
import openfl.net.URLRequest;
import openfl.net.URLLoaderDataFormat;
import openfl.events.HTTPStatusEvent;
import openfl.events.ProgressEvent;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.Loader;
import openfl.net.URLLoader;

// HAXE PACKAGES
import haxe.Timer;

/**
 * <b>CICLOPE MANAGANA - www.ciclope.com.br / www.managana.org</b><br>
 * <b>License:</b> GNU LGPL version 3<br><br>
 * GraphicSprite extends BaseSprite to enable simple download and display of picture files - PNG, JPG and GIF (also SWF on Flash target).
 * @author Lucas Junqueira <lucas@ciclope.art.br>
 */
class GraphicSprite extends BaseSprite
{

	// PRIVATE VALUES
	
	private var _loader:URLLoader;				// a loader for fetching graphic content
	#if flash
		private var _graphicFL:Loader;			// the bitmap display for flash target
	#else
		private var _graphic:Bitmap;			// the bitmap display
		private var _timer:Timer;				// a timer to check bitmap load
	#end
	
	/**
	 * GraphicSprite constructor.
	 */
	public function new() 
	{
		super();
		this._mediaType = MediaInfo.TYPE_GRAPHIC;
		// prepare loader
		this._loader = new URLLoader();
		this._loader.dataFormat = URLLoaderDataFormat.BINARY;
		this._loader.addEventListener(Event.COMPLETE, onLoaderComplete);
		this._loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onLoaderHttpStatus);
		this._loader.addEventListener(Event.UNLOAD, onLoaderUnload);
		this._loader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderIoError);
		this._loader.addEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
		// prepare display
		#if flash
			this._graphicFL = new Loader();
			this._graphicFL.contentLoaderInfo.addEventListener(Event.COMPLETE, onFLLoaderComplete);
			this.addChild(this._graphicFL);
		#else
			this._graphic = new Bitmap();
			this.addChild(this._graphic);
		#end
		
	}
	
	// GETTERS/SETTERS
	
	/**
	 * Display width.
	 */
	#if flash
		@:setter(width)
		override public function set_width(value:Float):Void
		{
			super.width = value;
			this._graphicFL.width = value;
		}
	#else
		override public function set_width(value:Float):Float
		{
			super.width = value;
			this._graphic.width = value;
			return (value);
		}
	#end
	
	/**
	 * Display height.
	 */
	#if flash
		@:setter(height)
		override public function set_height(value:Float):Void
		{
			super.height = value;
			this._graphicFL.height = value;
		}
	#else
		override public function set_height(value:Float):Float
		{
			super.height = value;
			this._graphic.height = value;
			return (value);
		}
	#end
	
	// PUBLIC METHODS
	
	/**
	 * Release resources used by the object.
	 */
	override public function dispose():Void
	{
		super.dispose();
		this._loader.removeEventListener(Event.COMPLETE, onLoaderComplete);
		this._loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onLoaderHttpStatus);
		this._loader.removeEventListener(Event.UNLOAD, onLoaderUnload);
		this._loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIoError);
		this._loader.removeEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
		this._loader = null;
		#if flash
			if (this._graphicFL.content != null) {
				if (Std.is(this._graphicFL.content, Bitmap)) {
					var bmp = cast(this._graphicFL.content, Bitmap);
					bmp.bitmapData.dispose();
				}
			}
			this._graphicFL.contentLoaderInfo.removeEventListener(Event.COMPLETE, onFLLoaderComplete);
			this._graphicFL = null;
		#else
			if (this._graphic.bitmapData != null) this._graphic.bitmapData.dispose();
			this._graphic = null;
			this._timer.stop();
			this._timer = null;
		#end
	}
	
	/**
	 * Start loading a new content.
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
			this._loading = true;
			this._loader.load(new URLRequest(this._tryURL));
			return (true);
		}
	}
	
	// PRIVATE METHODS
	
	/**
	 * The content was loaded.
	 */
	private function onLoaderComplete(evt:Event):Void
	{
		#if flash
			this._graphicFL.loadBytes(this._loader.data);
		#else
			if (this._graphic.bitmapData != null) this._graphic.bitmapData.dispose();
			#if lime_legacy
				this._graphic.bitmapData = BitmapData.loadFromBytes(this._loader.data);
			#else
				this._graphic.bitmapData = BitmapData.fromBytes(this._loader.data);
			#end
			this._timer = new Timer(100);
			this._timer.run = this.checkBitmapLoad;
		#end
		this._url = this._tryURL;
		this._tryURL = '';
		this._loading = false;
	}
	
	/**
	 * Graphic display update (for HTML5 load checking).
	 */
	private function checkBitmapLoad():Void
	{
		if ((this._graphic.bitmapData.width != 0) && (this._graphic.bitmapData.height != 0)) {
			this._loaded = true;
			if (this.playOnLoad) {
				this._state = MediaInfo.STATE_PLAY;
			} else {
				this._state = MediaInfo.STATE_PAUSE;
			}
			this._timer.stop();
			this._timer = null;
			
			this._graphic.width = this._width;
			this._graphic.height = this._height;
			
			this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOADED, MediaInfo.TYPE_GRAPHIC));
		}
	}
	
	/**
	 * Error while loading the content.
	 */
	private function onLoaderIoError(evt:Event):Void
	{
		this._tryURL = '';
		this._loading = false;
		this._loaded = false;
		this._state = MediaInfo.STATE_UNKNOWN;
		this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOAD_ERROR, MediaInfo.TYPE_GRAPHIC));
	}
	
	/**
	 * Content unloaded.
	 */
	private function onLoaderUnload(evt:Event):Void
	{
	}
	
	/**
	 * Content load HTTP status.
	 */
	private function onLoaderHttpStatus(evt:Event):Void
	{
	}
	
	/**
	 * Content load progress.
	 */
	private function onLoaderProgress(evt:Event):Void
	{
	}
	
	/**
	 * Content loaded (for Flash target).
	 */
	private function onFLLoaderComplete(evt:Event):Void
	{
		this._loaded = true;
		if (this.playOnLoad) {
			this._state = MediaInfo.STATE_PLAY;
		} else {
			this._state = MediaInfo.STATE_PAUSE;
		}
		
		this._graphicFL.width = this._width;
		this._graphicFL.height = this._height;
		
		this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOADED, MediaInfo.TYPE_GRAPHIC));
	}
	
}