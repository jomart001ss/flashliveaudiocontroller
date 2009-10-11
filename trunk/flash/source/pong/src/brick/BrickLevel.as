package brick 
{
	import flash.events.TimerEvent;

	import fla.brick.Pad;

	import voice.VoiceData;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;

	/**
	 * Brick level.
	 * Creates complete game specified by level number.
	 * 
	 * @author Patrick Brouwer [patrick at inlet dot nl]
	 */
	public class BrickLevel extends Sprite 
	{

		private static const WIDTH : int = 608;
		private static const HEIGHT : int = 540;
		private static const PAD_FRICTION : Number = 0.1;
		private static const PAD_SIDE_OFFSET : Number = 20;
		private static const START_TIMEOUT : Number = 3;

		private var _levelNum : uint;
		private var _player1 : Pad;
		private var _player2 : Pad;
		private var _voiceDataPlayer1 : VoiceData;
		private var _voiceDataPlayer2 : VoiceData;
		private var _ball : Sprite;

		private var _gameStarted : Boolean;
		private var _timer : Timer;

		private var _speedBallX : Number;
		private var _speedBallY : Number;

		public function BrickLevel(levelNum : uint)
		{
			_levelNum = levelNum;
			_voiceDataPlayer1 = new VoiceData(0, 0);
			_voiceDataPlayer2 = new VoiceData(0, 0);
			
			_speedBallX = -1;
			_speedBallY = -1;
			
			createPads();
			createBall();
			
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
		}

		private function createPads() : void
		{
			_player1 = addChild(new Pad()) as Pad;
			_player2 = addChild(new Pad()) as Pad;
			_player1.y = 400;
			_player2.y = 430;
		}

		private function createBall() : void
		{
			_ball = addChild(new Sprite()) as Sprite;
			with (_ball.graphics)
			{
				beginFill(0xffffff);
				drawRect(2, 0, 6, 8);
				endFill();
				beginFill(0xffffff);
				drawRect(0, 2, 10, 4);
				endFill();
			}
		}

		public function input(inVoiceData : Array) : void
		{
			_voiceDataPlayer1 = inVoiceData[0];
			_voiceDataPlayer2 = inVoiceData[1];
		}

		/**
		 * Main game loop
		 * 
		 * @param event:Event Event.ENTER_FRAME
		 */
		private function loop(event : Event) : void
		{
			// speed x increment of both players
			var pl1_speedX : Number = (Math.min(WIDTH, Math.max(0, WIDTH * _voiceDataPlayer1.pitch)) - _player1.x) * PAD_FRICTION;
			var pl2_speedX : Number = (Math.min(WIDTH, Math.max(0, WIDTH * _voiceDataPlayer2.pitch)) - _player2.x) * PAD_FRICTION;
			
			//			_player1.x += pl1_speedX;
			//			_player2.x += pl2_speedX;

			_player1.x = mouseX;
			_player2.x = mouseX - 100;
			
			// animate ball
			if (!_gameStarted)
			{
				_ball.y = _player1.y - _ball.height;
				_ball.x = _player1.x + _player1.width / 2 - _ball.width / 2;
			} else {
				// bounce ball on edges
				if (_ball.x < 0 || _ball.x > WIDTH - _ball.width) _speedBallX = -_speedBallX;
				if (_ball.y < 0) _speedBallY = -_speedBallY;
				
				bounceBallOnPad(_player1);
				bounceBallOnPad(_player2);
				
				_ball.x += _speedBallX;
				_ball.y += _speedBallY;
			}
		}

		private function bounceBallOnPad(pad : Pad) : void
		{
			if (_ball.hitTestObject(pad))
			{
				// check horizontal bouncing
				if (_ball.y + _ball.height > pad.y + 1 && _ball.y < pad.y + pad.height + 1)
				{
					// horizontal bouncing, reset pos
					if (_ball.x < pad.x + pad.width / 2) _ball.x = pad.x - _ball.width - 1; 
					if (_ball.x > pad.x + pad.width / 2) _ball.x = pad.x + pad.width + 1;
							
					_speedBallX = -_speedBallX;
				} else {
					// speed offset sides of the pad
//					if (_ball)
//					{
//											
//					}
					
					// vertical bouncing, reset pos
					if (_ball.y < pad.y + pad.height / 2) _ball.y = pad.y - _ball.height - 1; 
					if (_ball.y > pad.y + pad.height / 2) _ball.y = pad.y + pad.height + 1;
							
					_speedBallY = -_speedBallY;
				}
			}
		}

		private function handleAddedToStage(event : Event) : void
		{
			addEventListener(Event.ENTER_FRAME, loop);
			
			_timer = new Timer(START_TIMEOUT * 1000, 1);
			_timer.addEventListener(TimerEvent.TIMER, start);
			_timer.start();
		}

		private function start(event : TimerEvent) : void
		{
			removeEventListener(TimerEvent.TIMER, start);
			_gameStarted = true;
		}

		private function handleRemovedFromStage(event : Event) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
			removeEventListener(Event.ENTER_FRAME, loop);
			removeEventListener(TimerEvent.TIMER, start);
		}
	}
}
