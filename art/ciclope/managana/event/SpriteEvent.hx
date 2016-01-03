package art.ciclope.managana.event;

// CICLOPE CLASSES
import art.ciclope.managana.util.MediaInfo;

// OPENFL PACKAGES
import openfl.events.Event;

/**
 * <b>CICLOPE MANAGANA - www.ciclope.com.br / www.managana.org</b><br>
 * <b>License:</b> GNU LGPL version 3<br><br>
 * SpriteEvent provides event types for Managana media sprite classes.
 * @author Lucas Junqueira <lucas@ciclope.art.br>
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

	/**
	 * SpriteEvent constructor.
	 * @param	type	event type
	 * @param	mtype	sprite media type
	 * @param	bubbles	can bubble?
	 * @param	cancelable	is cancelable?
	 */
	public function new(type:String, mtype:String=MediaInfo.TYPE_UNKNOWN, bubbles:Bool=false, cancelable:Bool=false)
	{
		super(type, bubbles, cancelable);
		this.mediaType = mtype;
	}
	
}