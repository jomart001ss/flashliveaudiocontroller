package pong 
{
	import fla.pong.Ball;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	public class PongBall extends Ball 
	{

		private static const EXTRA_SPEED_PER_BOUNCE:Number = 2;
		private static const INITIAL_SPEED:Number = 2;
		//
		private var _padLeft:Sprite;
		private var _padRight:Sprite;
		private var _direction:Point;
		private var _toRight:Boolean;
		//
		public static const SCORE_EVENT:String = "pong_score";

		public function PongBall() 
		{
			_direction = new Point();
		}

		public function addPlayers( left:Sprite, right:Sprite ):void 
		{
			_padLeft = left;
			_padRight = right;
		}

		public function start(toRight:Boolean = true):void 
		{
			_toRight = toRight;
			reset();
			addEventListener(Event.ENTER_FRAME,handleEnterFrame);
		}

		private function handleEnterFrame(event:Event):void
		{
			moveBall();
		}

		private function moveBall():void
		{
			//bounce to top and bottom
			if (y <= 0 || y >= stage.stageHeight)
			{
				_direction.y = -(_direction.y);
			}
			
			//if (x <= 0 || x >= stage.stageWidth)
			//bounce to pads
			if (hitTestObject(_padLeft) || hitTestObject(_padRight)) 
			{
				//speed up
				_direction.x += _direction.x < 0 ? -EXTRA_SPEED_PER_BOUNCE : EXTRA_SPEED_PER_BOUNCE;
                
				x += x > stage.stageWidth / 2 ? -10 : 10;

				//bounce
				_direction.x = -(_direction.x);
			}
			
			if (x <= -10 || x >= stage.stageWidth + 10)
			{
				if(x < stage.width / 2)
				{
					_padLeft.dispatchEvent(new Event(SCORE_EVENT));
				}
				else
				{
					_padRight.dispatchEvent(new Event(SCORE_EVENT));
				}
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
			
			if(_toRight)
			{
				_direction.x = INITIAL_SPEED;
				_direction.y = INITIAL_SPEED;
			}
			else
			{
				_direction.x = -INITIAL_SPEED;
				_direction.y = -INITIAL_SPEED;
			}
		}
	}
}
