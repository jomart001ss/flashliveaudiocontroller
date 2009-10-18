package pong
{
	import util.NumberUtils;

	import fla.pong.WinnerSign;
	import fla.pong.Background;
	import fla.pong.CounterDisplay;
	import fla.pong.Pad;

	import gs.TweenLite;

	import voice.BaseVoiceApplication;
	import voice.VoiceDataEvent;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 *	@author Jankees.van.Woezik (base42.nl)
	 *	@author Patrick.Brouwer (base42.nl)
	 *	@version 2.0
	 */
	public class Pong extends BaseVoiceApplication
	{

		public static const GAME_WIDTH:Number = 800;
		public static const GAME_HEIGHT:Number = 600;
		private static const MARGIN:Number = 10;
		private static const SCORE_TO_WIN:Number = 10;
		//
		private var _padLeft:Pad;
		private var _padRight:Pad;
		private var _ball:PongBall;
		private var _background:DisplayObject;
		private var _displayLeft:CounterDisplay;
		private var _displayRight:CounterDisplay;
		private var _winnerSign:WinnerSign;

		public function Pong() 
		{
			addEventListener(Event.ADDED_TO_STAGE,addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,removedFromStage);
		}

		private function removedFromStage(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,removedFromStage);
			if (_ball)
			{
				_ball.dispose();
				_ball = null;
			}
		}

		private function addedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,addedToStage);
			
			_background = addChild(new Background());
			
			_padLeft = new PongPad();
			_padRight = new PongPad();
			
			_ball = new PongBall();
			_ball.addPlayers(_padLeft,_padRight);
			
			addChild(_ball);
			
			_padLeft.x = MARGIN;
			_padRight.x = _background.width - MARGIN;
			
			_padLeft.addEventListener(PongBall.SCORE_EVENT,score);
			_padRight.addEventListener(PongBall.SCORE_EVENT,score);
			
			_displayLeft = new CounterDisplay();
			_displayRight = new CounterDisplay();
			
			addChild(_displayLeft);
			addChild(_displayRight);
			
			addChild(_padLeft);
			addChild(_padRight);
			
			_displayLeft.x = 220;
			_displayLeft.y = 60;
			_displayRight.x = _displayLeft.x + 210;
			_displayRight.y = 60;
			
			_winnerSign = new WinnerSign();
			_winnerSign.x = stage.stageWidth / 2;
			_winnerSign.y = stage.stageHeight / 2;
			_winnerSign.visible = false;
			addChild(_winnerSign);
			
			start();
		}

		private function score(event:Event):void
		{
			if(event.target == _padLeft)
			{
				setDisplay(Number(_displayLeft.counter.text),Number(_displayRight.counter.text) + 1);
			}else if(event.target == _padRight)
			{
				setDisplay(Number(_displayLeft.counter.text) + 1,Number(_displayRight.counter.text));
			}
			if(Number(_displayLeft.counter.text) >= SCORE_TO_WIN || Number(_displayRight.counter.text) >= SCORE_TO_WIN)
			{
				//we have a winner
				if(Number(_displayLeft.counter.text) > Number(_displayRight.counter.text))
				{
					_winnerSign.tHeader.text = "LEFT WINS!";
				}
				else
				{
					_winnerSign.tHeader.text = "RIGHT WINS!";
				}
				_winnerSign.tTime.text = "10";
				
				_winnerSign.visible = true;
				
				TweenLite.delayedCall(1,countDown);
			}
			else
			{
				TweenLite.delayedCall(1,_ball.start,[event.target == _padLeft]);
			}
		}

		private function countDown():void
		{
			if(Number(_winnerSign.tTime.text) <= 0)
			{
				_winnerSign.visible = false;
				start();
			}
			else
			{
				TweenLite.delayedCall(1,countDown);
			}
			_winnerSign.tTime.text = "0" + (Number(_winnerSign.tTime.text) - 1);
		}

		override protected function handleVoiceEvents(event:VoiceDataEvent):void
		{
			super.handleVoiceEvents(event);
			
			movePads();
		}

		private function start():void
		{ 
			setDisplay(0,0);
			_ball.start();
		}

		private function setDisplay(inLeft:Number,inRight:Number):void
		{
			
			_displayLeft.counter.text = String(inLeft);
			_displayRight.counter.text = String(inRight);
			
			if(inLeft < 10) _displayLeft.counter.text = 0 + _displayLeft.counter.text;
			if(inRight < 10) _displayRight.counter.text = 0 + _displayRight.counter.text;
		}

		private function movePads():void
		{
			var newY:Number;
			if (_voiceDataLeft.pitch > 0) 
			{
				
				newY = _padLeft.y + (calculateNewVerticalPosition(_voiceDataLeft.pitch) - _padLeft.y) * 0.1;
				newY = NumberUtils.limit(newY,0,GAME_HEIGHT);    
				_padLeft.scaleY = (_voiceDataLeft.amplitude / 80);    
			}
            
			if (_voiceDataRight.pitch > 0) 
			{
				newY = _padRight.y + (calculateNewVerticalPosition(_voiceDataRight.pitch) - _padRight.y) * 0.1;
				_padRight.y = newY;
				_padRight.scaleY = (_voiceDataRight.amplitude / 80);    
			}
		}

		private function calculateNewVerticalPosition(inPitch:Number):Number
		{
			return stage.stageHeight - (stage.stageHeight * inPitch);
		}
	}
}
