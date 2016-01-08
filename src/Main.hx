package;

import haxe.Timer;
import openfl.display.Loader;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.ColorTransform;
import openfl.Lib;
import openfl.Assets;
import openfl.net.URLRequest;
import openfl.system.ApplicationDomain;
import openfl.system.LoaderContext;

import art.ciclope.managana.display.GraphicSprite;
import art.ciclope.managana.display.VideoSprite;
import art.ciclope.managana.display.AudioSprite;
import art.ciclope.managana.display.TextSprite;
import art.ciclope.managana.display.MediaSprite;
import art.ciclope.managana.display.PageSprite;
import art.ciclope.managana.event.SpriteEvent;
import art.ciclope.managana.util.MediaInfo;

/**
 * ...
 * @author Lucas S. Junqueira
 */
class Main extends Sprite 
{
	
	private var _sprite:GraphicSprite;
	private var _vsprite:VideoSprite;
	private var _asprite:AudioSprite;
	private var _tsprite:TextSprite;
	private var _msprite:MediaSprite;
	private var _psprite:PageSprite;
	
	private var _interval:Timer;
	
	private function onFontInit(evt:Event):Void
	{
		trace ('font loaded');
		this.showtext();
	}
	
	function showtext():Void
	{
		/*
		trace ('show text');
		this._tsprite = new TextSprite();
		this._tsprite.textAlign = MediaInfo.TEXTALIGN_RIGHT;
		this._tsprite.textDisplay = MediaInfo.TEXTDISPLAY_PARAGRAPH;
		this._tsprite.fontSize = 20;
		this._tsprite.fontColor = 0xFF9900;
		this._tsprite.fontBold = true;
		this._tsprite.fontItalic = false;
		this._tsprite.maxChars = 0;
		this._tsprite.leading = 0;
		this._tsprite.letterSpacing = 0;
		this._tsprite.setText('aqui um primeiro texto que tem que ser bem grande pra ver a quebra de linhas - e tem que ver também o que acontece quando o texto ultrapassa o limite vertical do objeto, porque parece que ele continua crescendo ao infinito e não é isso que eu quero!');
		//this._tsprite.setHTMLText('testando agora texto html<br />quebra de linha<br /><b>aqui com negrito</b><br /><i>e aqui, itálico</i>');
		//this._tsprite.load('http://localhost:2000/text.txt');
		//this._tsprite.loadHTML('http://localhost:2000/htmltext.html');
		this.addChild(this._tsprite);
		*/
	}

	public function new() 
	{
		super();
		/*
		this._sprite = new GraphicSprite();
		this._sprite.addEventListener(SpriteEvent.CONTENT_LOADED, onLoaded);
		this._sprite.playOnLoad = false;
		this.addChild(this._sprite);
		this._sprite.load('http://localhost:2000/logo.png');
		
		this._vsprite = new VideoSprite();
		this._vsprite.addEventListener(SpriteEvent.CONTENT_LOADED, onLoaded);
		this._vsprite.playOnLoad = false;
		this.addChild(this._vsprite);
		this._vsprite.load('http://localhost:2000/sonic.mp4');
		
		this._asprite = new AudioSprite();
		this._asprite.playOnLoad = false;
		this._asprite.load('http://localhost:2000/audio.mp3');
		
		*/
		#if flash
			trace ('loading fonts');
			/*var FreeUniversalLoader:Loader = new Loader();
			FreeUniversalLoader.contentLoaderInfo.addEventListener(Event.INIT, onFontInit);
			FreeUniversalLoader.load(new URLRequest('FreeUniversal.swf'), new LoaderContext(false, ApplicationDomain.currentDomain, null));
			var GentiumLoader:Loader = new Loader();
			GentiumLoader.load(new URLRequest('Gentium.swf'));*/
			var MarvelLoader:Loader = new Loader();
			MarvelLoader.contentLoaderInfo.addEventListener(Event.INIT, onFontInit);
			MarvelLoader.load(new URLRequest('Marvel.swf'), new LoaderContext(false, ApplicationDomain.currentDomain, null));
		#else
			this.showtext();
		#end
		
		/*this._tsprite = new TextSprite();
		this._tsprite.textAlign = MediaInfo.TEXTALIGN_RIGHT;
		this._tsprite.fontSize = 20;
		this._tsprite.fontColor = 0xFF9900;
		this._tsprite.fontBold = true;
		this._tsprite.fontItalic = true;
		this._tsprite.load('aqui um primeiro texto que tem que ser bem grande pra ver a quebra de linhas - e tem que ver também o que acontece quando o texto ultrapassa o limite vertical do objeto, porque parece que ele continua crescendo ao infinito e não é isso que eu quero!');
		this.addChild(this._tsprite);*/
		
		this.addEventListener(MouseEvent.CLICK, onClick);
		
		this._interval = new Timer(1000);
		this._interval.run = this.onInterval;
		
		//this._msprite = new MediaSprite();
		//this.addChild(this._msprite);
		//this._msprite.loadGraphic('http://localhost:2000/logo.png');
		
		this._psprite = new PageSprite();
		this.addChild(this._psprite);
		this._psprite.loadGraphic('http://localhost:2000/logo.png');
		this._psprite.transition = PageSprite.TRANSITION_FROMRIGHT;
		
		this._psprite.x = 0;
		this._psprite.y = 0;
		this._psprite.rotation = 45;
		
		this._psprite.setRed(250);
		
		//this._psprite.loadVideo('http://localhost:2000/sonic.mp4');
		
		/*
		this._sprite = new GraphicSprite();
		this.addChild(this._sprite);
		this._sprite.load('logo.png');
		*/
		
		// Assets:
		// openfl.Assets.getBitmapData("img/assetname.jpg");
		
	}
	
	private function onInterval():Void
	{
		//trace ('update', this._asprite.update());

		//this._sprite.update();
		//this._vsprite.update();
		//this._asprite.update();
	//	this._tsprite.update();
	}

	
	private function onLoaded(evt:SpriteEvent):Void
	{
		trace ('loaded', evt.mediaType, evt.target);
		trace (this._sprite.url, this._vsprite.url);
	}
	
	private function onClick(evt:MouseEvent):Void
	{
		trace ('click');
		if (this._psprite.url == 'http://localhost:2000/logo.png') this._psprite.loadGraphic('http://localhost:2000/logoofl.png');
			else this._psprite.loadGraphic('http://localhost:2000/logo.png');
	}
}
