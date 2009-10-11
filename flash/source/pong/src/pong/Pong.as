package pong
{
	import fla.pong.Background;
	import fla.pong.Ball;
	import fla.pong.Pad;

	import voice.BaseVoiceApplication;
	import voice.VoiceDataEvent;

	import flash.display.DisplayObject;

	/**
	 *	@author Jankees.van.Woezik (base42.nl)
	 *	@author Patrick.Brouwer (base42.nl)
	 *	@version 2.0
	 */
	public class Pong extends BaseVoiceApplication
	{

		private var _padLeft:Pad;
		private var _padRight:Pad;
		private static const MARGIN:Number = 10;
		private static const DEFAULT_Y_VALUE_PAD:int = 321;
		private var _ball:Ball;

		public function Pong() 
		{
		
			
			var background:DisplayObject = addChild(new Background());
			
			_padLeft = new Pad();
			_padRight = new Pad();
			
			_ball = new Ball();
			addChild(_ball);
			
			_padLeft.x = MARGIN;
			_padRight.x = background.width - MARGIN;
			
			addChild(_padLeft);
			addChild(_padRight);
		}

		override protected function handleVoiceEvents(event:VoiceDataEvent):void
		{
			_voiceDataLeft = event.data[0];
			_voiceDataRight = event.data[1];
			
			movePads();
		}

		private function movePads():void
		{
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
