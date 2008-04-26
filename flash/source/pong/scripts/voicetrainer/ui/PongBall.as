package voicetrainer.ui {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import voicetrainer.events.GameEvent;

	public class PongBall extends Sprite {
		
		private var mBall:Sprite;
		private var mPadPlayerOne:Sprite;
		private var mPadPlayerTwo:Sprite;
		
		private var mSpeed:Number;
		private var mDirection:Object;
		
		private var mTimer:Timer;
		
		public function PongBall( ball:Sprite ) {
			mTimer = new Timer(1000);
			mBall = ball;
		}
		
		public function addPlayers( left:Sprite, right:Sprite ) : void {
			mPadPlayerOne = left;
			mPadPlayerTwo = right;
		}

		public function start() : void {
			var x:Number = 2;
			var y:Number = Math.floor(Math.random() * 3) + 1;
			
			mDirection = { x:x, y:y };
			mSpeed = 0.5;
			mBall.addEventListener(Event.ENTER_FRAME, moveBall);
		}
		
		private function moveBall( e : Event ) : void {
			if (mBall.y <= (mBall.height/2) || mBall.y >= (400-(mBall.height/2))) mDirection.y = -(mDirection.y);
			if (mBall.hitTestObject(mPadPlayerOne) || mBall.hitTestObject(mPadPlayerTwo)) {
				mDirection.x = -(mDirection.x + 0.5);
				mSpeed += 0.1;
			}
			mBall.y += mDirection.y*mSpeed;
			mBall.x += mDirection.x*mSpeed;
			
			if (mBall.x < -10 || mBall.x > 560) {
				if (mBall.x < -10) dispatchEvent(new GameEvent(GameEvent.SCORED, false, false, "left"));
				if (mBall.x > 560) dispatchEvent(new GameEvent(GameEvent.SCORED, false, false, "right"));
				
				reset();
			}
		}

		public function reset() : void {
			mBall.removeEventListener(Event.ENTER_FRAME, moveBall);
			mBall.x = 275;
			mBall.y = 200;
			
			mTimer = new Timer(1000);
			mTimer.addEventListener(TimerEvent.TIMER, runOnce);
			mTimer.start();
		}
		
		private function runOnce( e : TimerEvent ) : void {
			mTimer.removeEventListener(TimerEvent.TIMER, runOnce);
			start();
		}
	}
}
