package art.ciclope.managana.display;

// CICLOPE CLASSES
import art.ciclope.managana.display.BaseSprite;
import art.ciclope.managana.util.MediaInfo;
import art.ciclope.managana.event.SpriteEvent;

// OPENFL PACKAGES
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.events.IOErrorEvent;
import openfl.events.Event;
import openfl.events.ProgressEvent;
import openfl.net.URLRequest;

/**
 * <b>CICLOPE MANAGANA - www.ciclope.com.br / www.managana.org</b><br>
 * <b>License:</b> GNU LGPL version 3<br><br>
 * AudioSprite extends BaseSprite to enable simple download and playback of audio files. The supported format/codecs depend on the target/browser.
 * @author Lucas Junqueira <lucas@ciclope.art.br>
 */
class AudioSprite extends BaseSprite
{
	
	// PRIVATE VALUES
	
	private var _sound:Sound;				// the sound loader
	private var _channel:SoundChannel;		// sound playback channel

	/**
	 * AudioSprite constructor.
	 */
	public function new() 
	{
		super();
		this._mediaType = MediaInfo.TYPE_AUDIO;
		
		// prepare sound
		this._sound = new Sound();
		this._sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		this._sound.addEventListener(Event.OPEN, openHandler);
		this._sound.addEventListener(Event.COMPLETE, completeHandler);
		this._sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
	}
	
	// GETTERS/SETTERS
	
	/**
	 * Sprite time.
	 */
	override public function get_time():Int
	{
		if (this.state == MediaInfo.STATE_PAUSE) {
			return (this._time);
		} else if (this._loaded && (this._channel != null)) {
			return (Std.int(this._channel.position / 1000));
		} else {
			return (0);
		}
	}
	override public function set_time(value:Int):Int
	{
		if (this._loaded) this.seek(value);
		return (value);
	}
	
	// PUBLIC METHODS
	
	/**
	 * Start loading a new content.
	 * @param	url	the content url to start loading
	 * @return	true if the content download can start, false if there is something already downloading
	 */
	override public function load(url:String):Bool
	{
		if (!super.load(url)) {
			// currently loading another content
			return (false);
		} else {
			// start the download
			this._loading = true;
			// remove any previous sound
			if (this._sound != null) {
				try { this._sound.close(); } catch (e:Dynamic) { }
				this._sound.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				this._sound.removeEventListener(Event.OPEN, openHandler);
				this._sound.removeEventListener(Event.COMPLETE, completeHandler);
				this._sound.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				this._sound = null;
			}
			// prepare sound
			this._sound = new Sound();
			this._sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this._sound.addEventListener(Event.OPEN, openHandler);
			this._sound.addEventListener(Event.COMPLETE, completeHandler);
			this._sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			this._sound.load(new URLRequest(url));
			return (true);
		}
	}
	
	/**
	 * Start media playback.
	 * @param	time	the starting time in seconds (-1 for current time)
	 */
	override public function play(time:Int = -1):Void
	{
		if (this._loaded) {
			// stop previous sound channel
			if (this._channel != null) {
				this._channel.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
				this._channel.stop();
				this._channel = null;
			}
			// start playback
			if (time >= 0) {
				this._channel = this._sound.play(time * 1000);
			} else {
				this._channel = this._sound.play(this.time * 1000);
			}
			#if html5
				this._totalTime = this._channel.audioDuration;
			#else
				this._totalTime = Std.int(this._sound.length / 1000);
			#end
			//this._channel.soundTransform = this._soundTransform;
			this._channel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
			super.play();
		}
	}
	
	/**
	 * Pause media playback.
	 */
	override public function pause():Void
	{
		if (this._loaded && (this._channel != null)) {
			super.pause();
			this._time = this.time;
			this._channel.stop();
		}
	}
	
	/**
	 * Stop media playback.
	 */
	override public function stop():Void
	{
		if (this._loaded) {
			super.stop();
			this.pause();
			this.seek(0);
		}
	}
	
	/**
	 * Set media playback time position.
	 * @param	to	the time (seconds) to go to
	 */
	override public function seek(to:Int):Void
	{
		super.seek(to);
		if (this.state == MediaInfo.STATE_PLAY) {
			this.play(to);
		} else {
			this.play(to);
			this.pause();
		}
	}
	
	/**
	 * Release resources used by the object.
	 */
	override public function dispose():Void 
	{
		super.dispose();
		if (this._sound != null) {
			try { this._sound.close(); } catch (e:Dynamic) { }
			this._sound.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this._sound.removeEventListener(Event.OPEN, openHandler);
			this._sound.removeEventListener(Event.COMPLETE, completeHandler);
			this._sound.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			this._sound = null;
		}
		if (this._channel != null) {
			this._channel.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
			this._channel.stop();
			this._channel = null;
		}
	}
	
	// PRIVATE METHODS
	
	/**
	 * IO error event.
	 */
	private function ioErrorHandler(evt:IOErrorEvent):Void
	{
		this._tryURL = '';
		this._loading = false;
		this._loaded = false;
		this._state = MediaInfo.STATE_UNKNOWN;
		this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOAD_ERROR, MediaInfo.TYPE_AUDIO));
	}
	
	/**
	 * OPEN error event.
	 */
	private function openHandler(evt:Event):Void
	{
		
	}
	
	/**
	 * COMPLETE error event.
	 */
	private function completeHandler(evt:Event):Void
	{
		this._loaded = true;
		this._loading = false;
		this._url = this._tryURL;
		this._tryURL = '';
		if (this.playOnLoad) {
			this.play(0);
		}
		this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOADED, MediaInfo.TYPE_AUDIO));
	}
	
	/**
	 * PROGRESS error event.
	 */
	private function progressHandler(evt:ProgressEvent):Void
	{
		
	}
	
	/**
	 * Sound playback reaches the end of the file.
	 */
	private function soundComplete(evt:Event):Void 
	{
		if (this.loop) {
			this.play(0);
			this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_LOOP, this.mediaType));
		} else {
			this.pause();
			this.dispatchEvent(new SpriteEvent(SpriteEvent.CONTENT_END, this.mediaType));
		}
	}
	
}