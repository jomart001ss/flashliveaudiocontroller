package brick 
{
	import fla.brick.Pad;

	import nl.inlet42.log.Logger;

	import util.NumberUtils;

	import voice.VoiceData;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * Brick level.
	 * Creates complete game specified by level number.
	 * 
	 * @author Patrick Brouwer [patrick at inlet dot nl]
	 */
	public class BrickLevel extends Sprite 
	{

		public static const WIDTH : int = 608;
		public static const HEIGHT : int = 540;
		private static const PAD_FRICTION : Number = 0.1;
		private static const PAD_SIDE_OFFSET : Number = 15;
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
		private var _field : Field;
		private var _blockthathasbeenhit : Block;

		private var _lastX : Number;
		private var _lastY : Number;

		public function BrickLevel(levelNum : uint)
		{
			_levelNum = levelNum;
			_voiceDataPlayer1 = new VoiceData(0, 0);
			_voiceDataPlayer2 = new VoiceData(0, 0);

			_field = new Field(_levelNum);
			addChild(_field);
			
			_speedBallX = -50;
			_speedBallY = -50;
			
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
			
			_player1.scaleX = 20;
			_player2.scaleX = 20;
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
			_blockthathasbeenhit = _field.hitTest(_ball);
			if(_blockthathasbeenhit)
			{
				bounceBallOnObject(_blockthathasbeenhit);
				_blockthathasbeenhit.tryRemove();
			}
			
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
				_ball.y = _player1.y - _ball.height - 10;
				_ball.x = _player1.x + _player1.width / 2 - _ball.width / 2;
			} else {
				// bounce ball on edges
				if (_ball.x < 0 || _ball.x > WIDTH - _ball.width) 
				{
					_ball.x = _lastX;
					_speedBallX = -_speedBallX;
				}
				
				if (_ball.y < 0) 
				{
					_ball.y = _lastY;
					_speedBallY = -_speedBallY;
				}
				
				bounceBallOnObject(_player1);
				bounceBallOnObject(_player2);
				
				_speedBallX = NumberUtils.limit(_speedBallX, -8, 8);
				_speedBallY = NumberUtils.limit(_speedBallY, -8, 8);
				
				_ball.x += _speedBallX;
				_ball.y += _speedBallY;
			}
			
			_lastX = _ball.x;
			_lastY = _ball.y;
		}

		private function bounceBallOnObject(obj : Sprite) : void
		{
			if (_ball.hitTestObject(obj))
			{
				if (_lastY + _ball.height > obj.y + 2 && _lastY < (obj.y + obj.height) - 2 )
				{
					// horizontal hitting
					_ball.x = _lastX;
					_speedBallX = -_speedBallX;
				} else {
					// vertical hitting
					_ball.y = _lastY;
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
