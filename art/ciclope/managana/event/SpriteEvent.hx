package art.ciclope.managana.event;

// CICLOPE CLASSES
import art.ciclope.managana.util.MediaInfo;

// OPENFL PACKAGES
import openfl.events.Event;

/**
 * ...
 * @author Lucas S. Junqueira
 */
class SpriteEvent extends Event
{
	
	// CONSTANTS
	
	/**
	 * A new content was just loaded.
	 */
	inline public static var CONTENT_LOADED = 'CONTENT_LOADED';
	
	/**
	 * The requested content failed to load.
	 */
	inline public static var CONTENT_LOAD_ERROR = 'CONTENT_LOAD_ERROR';
	
	/**
	 * The current content playback just looped.
	 */
	inline public static var CONTENT_LOOP = 'CONTENT_LOOP';
	
	/**
	 * The current content playback just ended.
	 */
	inline public static var CONTENT_END = 'CONTENT_END';
	
	// PUBLIC VALUES
	
	/**
	 * The current media type.
	 */
	public var mediaType:String = MediaInfo.TYPE_UNKNOWN;

	public function new(type:String, mtype:String=MediaInfo.TYPE_UNKNOWN, bubbles:Bool=false, cancelable:Bool=false)
	{
		super(type, bubbles, cancelable);
		this.mediaType = mtype;
	}
	
}