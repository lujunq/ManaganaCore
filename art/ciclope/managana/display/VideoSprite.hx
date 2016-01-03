package art.ciclope.managana.display;

// CICLOPE CLASSES
import art.ciclope.managana.display.BaseSprite;
import art.ciclope.managana.util.MediaInfo;
import art.ciclope.managana.event.SpriteEvent;

// OPENFL PACKAGES
import openfl.events.SecurityErrorEvent;
import openfl.events.IOErrorEvent;
import openfl.events.NetStatusEvent;
import openfl.events.AsyncErrorEvent;
import openfl.net.NetConnection;
import openfl.net.NetStream;
import openfl.media.Video;
import openfl.display.Shape;

/**
 * <b>CICLOPE MANAGANA - www.ciclope.com.br / www.managana.org</b><br>
 * <b>License:</b> GNU LGPL version 3<br><br>
 * VideoSprite extends BaseSprite to enable simple download and display of video files. The supported format/codecs depend on the target/browser.
 * @author Lucas Junqueira <lucas@ciclope.art.br>
 */
class VideoSprite extends BaseSprite
{
	
	// PRIVATE VALUES
	
	private var _connection:NetConnection;			// video download connection
	private var _stream:NetStream;					// video stream
	private var _video:Video;						// video output
	
	#if html5
		/* HTML5 video size and click fix */
		private var _sizeSet:Bool = false;			// initial size already set?
		private var _bg:Shape;						// clickable background
	#end

	/**
	 * VideoSprite constructor.
	 */
	public function new() 
	{
		super();
		this._mediaType = MediaInfo.TYPE_VIDEO;
		
		#if html5
			// adding the clickable background
			this._bg = new Shape();
			this._bg.graphics.beginFill(0x000000, 0);
			this._bg.graphics.drawRect(0, 0, 100, 100);
			this._bg.graphics.endFill();
			this.addChild(this._bg);
		#end
		
		// prepare video display
		this._video = new Video(160, 90);
		this.addChild(this._video);
		// prepare video connection
		this._connection = new NetConnection();
		this._connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		this._connection.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		this._connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		this._connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
		this._connection.connect(null);
		// prepare video stream
		this._stream = new NetStream(this._connection);
		this._stream.checkPolicyFile = true;
		this._stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
		this._stream.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		this._stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		var clientObj:Dynamic = {
			'onMetaData': this.metadataEvent,
			'onImageData': this.imagedataEvent,
			'onPlayStatus': this.playstatusEvent,
			'onCuePoint': this.cuepointEvent
			};
		this._stream.client = clientObj;
		this._video.attachNetStream(this._stream);
	}
	
	// GETTERS/SETTERS
	
	/**
	 * Sprite time.
	 */
	override public function get_time():Int
	{
		if (this._loaded) {
			#if html5
				return (this._video.currentTime);
			#else
				return (Std.int(this._stream.time));
			#end
		} else {
			return (0);
		}
	}
	override public function set_time(value:Int):Int
	{
		if (this._loaded) this.seek(value);
		return (value);
	}
	
	/**
	 * Display width.
	 */
	#if flash
		@:setter(width)
		override public function set_width(value:Float):Void
		{
			super.width = value;
			this._video.width = value;
		}
	#else
		override public function set_width(value:Float):Float
		{
			super.width = value;
			#if html5
				#if dom
					this._video.width = value;
				#else
					if (this._video.videoWidth != 0) {
						this._video.scaleX = value / this._video.videoWidth;
						this._bg.width = value;
					}
				#end
			#else
				this._video.width = value;
			#end
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
			this._video.height = value;
		}
	#else
		override public function set_height(value:Float):Float
		{
			super.height = value;
			#if html5
				#if dom
					this._video.height = value;
				#else
					if (this._video.videoHeight != 0) {
						this._video.scaleY = value / this._video.videoHeight;
						this._bg.height = value;
					}
				#end
			#else
				this._video.height = value;
			#end
			return (value);
		}
	#end
	
	// PUBLIC METHODS
	
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
			this._stream.play(url);
			#if html5
				// for initial size fix
				this._sizeSet = false;
			#end
			return (true);
		}
	}
	
	/**
	 * Release resources used by the object.
	 */
	override public function dispose():Void 
	{
		super.dispose();
		#if html5
			this._bg.graphics.clear();
			this._bg = null;
		#end
		
		this._video.attachNetStream(null);
		this._video = null;
		this._connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		this._connection.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		this._connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		this._connection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
		this._connection = null;
		this._stream.client = null;
		this._stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
		this._stream.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		this._stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		this._stream = null;
	}
	
	/**
	 * Start media playback.
	 * @param	time	the starting time in seconds (-1 for current time)
	 */
	override public function play(time:Int = -1):Void
	{
		if (this._loaded) {
			super.play();
			this._stream.resume();
			if (time >= 0) {
				this.seek(time);
			}
		}
	}
	
	/**
	 * Pause media playback.
	 */
	override public function pause():Void
	{
		if (this._loaded) {
			super.pause();
			this._stream.pause();
		}
	}
	
	/**
	 * Set media playback time position.
	 * @param	to	the time (seconds) to go to
	 */
	override public function seek(to:Int):Void
	{
		if (this._loaded) {
			super.seek(to);
			#if html5
				this._video.currentTime = to;
			#else
				this._stream.seek(to);
			#end
		}
	}
	
	/**
	 * Stop media playback.
	 */
	override public function stop():Void
	{
		if (this._loaded) {
			super.stop();
			this._stream.pause();
			this._stream.seek(0);
		}
	}
	
	// PRIVATE METHODS
	
	/**
	 * Net status event.
	 */
	private function netStatusHandler(event:NetStatusEvent):Void {
		switch (event.info.code) {
			case 'NetStream.Play.Stop':
				if (this.time >= (this.totalTime - 1)) {
					if (this.loop) {
						this.seek(0);
						this.play();
						this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOOP, this.mediaType));
					} else {
						this.pause();
						this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_END, this.mediaType));
					}
				}
			case 'NetStream.Play.Start':
				if (!this._loaded) {
					#if html5
						// initial display size fix
						if (!this._sizeSet && (this._video.videoWidth != 0)) {
							this._sizeSet = true;
							this.width = this._width;
							this.height = this._height;
						}
						// video duration
						this._totalTime = this._video.videoDuration;
					#end
					this._loaded = true;
					this._loading = false;
					if (this.playOnLoad) {
						this._state = MediaInfo.STATE_PLAY;
					} else {
						this._state = MediaInfo.STATE_PAUSE;
						this.stop();
					}
					this._url = this._tryURL;
					this._tryURL = '';
					this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOADED, MediaInfo.TYPE_VIDEO));
				}
		}
	}
		
	/**
	 * IO error event.
	 */
	private function ioErrorHandler(evt:IOErrorEvent):Void {
		this._tryURL = '';
		this._loading = false;
		this._loaded = false;
		this._state = MediaInfo.STATE_UNKNOWN;
		this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOAD_ERROR, MediaInfo.TYPE_VIDEO));
	}
	
	/**
	 * Security error event.
	 */
	private function securityErrorHandler(evt:SecurityErrorEvent):Void {
		this._tryURL = '';
		this._loading = false;
		this._loaded = false;
		this._state = MediaInfo.STATE_UNKNOWN;
		this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOAD_ERROR, MediaInfo.TYPE_VIDEO));
	}
	
	/**
	 * Async error event.
	 */
	private function asyncErrorHandler(evt:AsyncErrorEvent):Void {  }
	
	/**
	 * Metadata received.
	 */
	private function metadataEvent(data:Dynamic):Void {
		if (data.duration != null) {
			this._totalTime = Std.int(Std.parseFloat(data.duration));
		} else if (data.totalduration != null) {
			this._totalTime = Std.int(Std.parseFloat(data.totalduration));
		}
	}
	
	/**
	 * Image data received.
	 */
	private function imagedataEvent(data:Dynamic):Void { }
	
	/**
	 * Playstatus data received.
	 */
	private function playstatusEvent(data:Dynamic):Void { }
	
	/**
	 * Cuepoint data received.
	 */
	private function cuepointEvent(data:Dynamic):Void {
		/*this.dispatchEvent(new Playing(Playing.MEDIA_CUE, this._stream, this._url, LoadedFile.TYPE_VIDEO, this._currentTime, this._totalTime, data));*/
	}
}