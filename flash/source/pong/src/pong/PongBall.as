package pong 
{
	import fla.pong.Ball;

	import nl.inlet42.log.Logger;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	public class PongBall extends Ball 
	{

		private var _padLeft:Sprite;
		private var _padRight:Sprite;
		private var mTimer:Timer;
		private var toRight:Boolean;
		private var _direction:Point;
		private static const EXTRA_SPEED_PER_BOUNCE:Number = 6;
		private var _timer:Timer;
		private static const INITIAL_SPEED:Number = 2;

		public function PongBall() 
		{
			mTimer = new Timer(1000);
			_direction = new Point();
		}

		public function addPlayers( left:Sprite, right:Sprite ):void 
		{
			_padLeft = left;
			_padRight = right;
		}

		public function start():void 
		{
			reset();
		}

		private function handleEnterFrame(event:Event):void
		{
			moveBall();
		}

		private function moveBall():void
		{
			//bounce to top and bottom
			if (y <= 0 || y >= stage.stageHeight) _direction.y = -(_direction.y);
			
			if (hitTestObject(_padLeft) || hitTestObject(_padRight)) 
			{
				//speed up
				_direction.x = _direction.x < 0 ? -EXTRA_SPEED_PER_BOUNCE : EXTRA_SPEED_PER_BOUNCE;

				//bounce
				_direction.x = -(_direction.x);
			}
			
			if (x <= -10 || x >= stage.stageWidth + 10)
			{
				Logger.debug("SCORE");
				reset();
			}
			
			x += _direction.x;
			y += _direction.y;
		}

		public function reset():void 
		{
			removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
			
			x = stage.stageWidth / 2;
			y = stage.stageHeight / 2;
			
			
			toRight = !toRight;
			
			if(toRight)
			{
				_direction.x = INITIAL_SPEED;
				_direction.y = INITIAL_SPEED;
			}
			else
			{
				_direction.x = -INITIAL_SPEED;
				_direction.y = -INITIAL_SPEED;
			}

			_timer = new Timer(1000,1);
			_timer.addEventListener(TimerEvent.TIMER,startMoving,false,0,true);	
			_timer.start();	
		}

		private function startMoving(event:TimerEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER,startMoving);
			_timer = null;
			
			Logger.debug("startMoving: ");
			addEventListener(Event.ENTER_FRAME,handleEnterFrame);
		}
	}
}
