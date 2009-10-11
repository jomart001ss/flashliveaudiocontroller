package pong
{
	import voice.VoiceData;

	import flash.display.DisplayObject;

	import fla.pong.Pad;
	import fla.pong.Background;

	import nl.inlet42.log.Logger;
	import nl.inlet42.log.connectors.TrazzleConnector;

	import voice.VoiceConnection;
	import voice.VoiceDataEvent;

	import flash.display.MovieClip;

	/**
	 *	@author Jankees.van.Woezik (base42.nl)
	 *	@author Patrick.Brouwer (base42.nl)
	 *	@version 2.0
	 */
	public class Pong extends MovieClip
	{

		private var _voice:VoiceConnection;
		private var _padLeft:Pad;
		private var _padRight:Pad;
		private var _voiceDataLeft:VoiceData;
		private var _voiceDataRight:VoiceData;
		private static const MARGIN:Number = 10;
		private static const DEFAULT_Y_VALUE_PAD:int = 321;

		public function Pong() 
		{
			Logger.addLogger(new TrazzleConnector());
			
			_voice = new VoiceConnection();
			_voice.addEventListener(VoiceDataEvent._EVENT,handleVoiceEvents);
			
			var background:DisplayObject = addChild(new Background());
			
			_padLeft = new Pad();
			_padRight = new Pad();
			
			_padLeft.x = MARGIN;
			_padRight.x = background.width - MARGIN;
			
			addChild(_padLeft);
			addChild(_padRight);
		}

		private function handleVoiceEvents(event:VoiceDataEvent):void
		{
			_voiceDataLeft = event.data[0];
			_voiceDataRight = event.data[1];
			
			if (_voiceDataLeft.pitch > 0) 
			{
				_padLeft.y += ((DEFAULT_Y_VALUE_PAD - _voiceDataLeft.pitch + 160) - _padLeft.y) * 0.1;    
				_padLeft.scaleY = (_voiceDataLeft.amplitude / 80);    
			}
            
			if (_voiceDataRight.pitch > 0) 
			{
				_padRight.y += ((DEFAULT_Y_VALUE_PAD - _voiceDataRight.pitch + 160) - _padRight.y) * 0.1;    
				_padRight.scaleY = (_voiceDataRight.amplitude / 80);    
			}
		}
	}
}
