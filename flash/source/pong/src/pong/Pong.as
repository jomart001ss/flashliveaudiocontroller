package pong
{
	import fla.pong.Background;
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

		private static const MARGIN:Number = 10;
		private var _padLeft:Pad;
		private var _padRight:Pad;
		private var _ball:PongBall;
		private var _background:DisplayObject;

		public function Pong() 
		{
			_background = addChild(new Background());
			
			_padLeft = new Pad();
			_padRight = new Pad();
			
			_ball = new PongBall();
			_ball.addPlayers(_padLeft,_padRight);
			
			addChild(_ball);
			
			
			_padLeft.x = MARGIN;
			_padRight.x = _background.width - MARGIN;
			
			addChild(_padLeft);
			addChild(_padRight);
			
			start();
		}

		override protected function handleVoiceEvents(event:VoiceDataEvent):void
		{
			super.handleVoiceEvents(event);
			
			movePads();
		}

		private function start():void
		{ 
			_ball.start();
		}

		private function movePads():void
		{
			if (_voiceDataLeft.pitch > 0) 
			{
				_padLeft.y += (calculateNewVerticalPosition(_voiceDataLeft.pitch) - _padLeft.y) * 0.1;    
				_padLeft.scaleY = (_voiceDataLeft.amplitude / 80);    
			}
            
			if (_voiceDataRight.pitch > 0) 
			{
				_padRight.y += (calculateNewVerticalPosition(_voiceDataRight.pitch) - _padRight.y) * 0.1;    
				_padRight.scaleY = (_voiceDataRight.amplitude / 80);    
			}
		}

		private function calculateNewVerticalPosition(inPitch:Number):Number
		{
			return stage.stageHeight - (stage.stageHeight * inPitch);
		}
	}
}
