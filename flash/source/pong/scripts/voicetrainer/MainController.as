package voicetrainer {
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import fl.motion.easing.Linear;
	import org.fwiidom.osc.OSCConnection;
	import org.fwiidom.osc.OSCConnectionEvent;
	import org.asaplibrary.util.actionqueue.ActionQueue;
	import org.asaplibrary.util.actionqueue.AQMove;
	import org.asaplibrary.util.actionqueue.AQScale;
	import voicetrainer.data.OscData;
	import voicetrainer.data.Input;
	import voicetrainer.utils.ScoreFormat;
	import voicetrainer.ui.PongBall;
	import voicetrainer.events.GameEvent;
	public class MainController extends Sprite {
		private static const STR_LOCAL_IP:String = "127.0.0.1";
		private static const NUM_PORT:int = 3000;
		private static const LINKAGE_PAD:String = "pad_mc";
		private static const LINKAGE_BALL:String = "ball_mc";
		private static const LINKAGE_BTN:String = "btn_mc";
		private static const LINKAGE_COUNTER:String = "counter_mc";
		private static const DEFAULT_Y_VALUE_PAD:int = 321;
		private var mOSC:OSCConnection;
		private var mPadPlayerOne:Sprite;
		private var mPadPlayerTwo:Sprite;
		private var mBall:Sprite;
		private var	mStartBtn:Sprite;
		private var mAq:ActionQueue;
		private var	mCounterLeft:TextField;
		private var	mCounterRight:TextField;
		private var mGame:PongBall;
		public function MainController() {
			createUI();
		}
		private function createUI():void {
			mPadPlayerOne = new (getDefinitionByName(LINKAGE_PAD))();
			mPadPlayerTwo = new (getDefinitionByName(LINKAGE_PAD))();
			mBall = new (getDefinitionByName(LINKAGE_BALL))();
			mStartBtn = new (getDefinitionByName(LINKAGE_BTN))();
            
			// game loop -> PongBall
						mGame = new PongBall(mBall);
			mGame.addPlayers(mPadPlayerOne, mPadPlayerTwo);
			mGame.addEventListener(GameEvent.SCORED, updateScore);
            
			var cLeft:Sprite = new (getDefinitionByName(LINKAGE_COUNTER))();
			var cRight:Sprite = new (getDefinitionByName(LINKAGE_COUNTER))();
			mCounterLeft = TextField(cLeft["counter"]);
			mCounterRight = TextField(cRight["counter"]);
            
			addChild(mCounterLeft);
			addChild(mCounterRight);
			addChild(mPadPlayerOne);
			addChild(mPadPlayerTwo);
			addChild(mBall);
			addChild(mStartBtn);
            
			initUI();
		}
		private function initUI():void {
			// ActionQueue for tweens
			mAq = new ActionQueue("pong");
			
			// default mc-settings
			mPadPlayerOne.x = 5;
			mPadPlayerTwo.x = 541;
			mPadPlayerTwo.y = DEFAULT_Y_VALUE_PAD;
			mPadPlayerOne.y = DEFAULT_Y_VALUE_PAD;
			mBall.x = 275;
			mBall.y = 200;
			mStartBtn.x = 218;
			mStartBtn.y = 64;
			mCounterLeft.x = 78;
			mCounterLeft.y = 68;
			mCounterRight.x = 362;
			mCounterRight.y = 68;
			
			// sets score to 0
			mCounterLeft.text = ScoreFormat.encode(0, 2);
			mCounterRight.text = ScoreFormat.encode(0, 2);
			
			// Starts game when clicked!
			mStartBtn.buttonMode = true;
			mStartBtn.useHandCursor = true;
			mStartBtn.addEventListener(MouseEvent.CLICK, startGame);
			
			// OSC events
			mOSC = new OSCConnection(STR_LOCAL_IP, NUM_PORT);
			mOSC.addEventListener(OSCConnectionEvent.ON_CONNECT, onConnect);
			mOSC.addEventListener(OSCConnectionEvent.ON_CONNECT_ERROR, onConnectError);
			mOSC.addEventListener(OSCConnectionEvent.ON_PACKET_IN, onPacketIn);
			mOSC.addEventListener(OSCConnectionEvent.ON_CLOSE, onClose);
			mOSC.connect();
		}
		private function startGame(e:MouseEvent):void {
			removeEventListener(MouseEvent.CLICK, startGame);
			removeChild(Sprite(e.target));
			
			mGame.start();
		}
		private function onConnect(e:OSCConnectionEvent):void {
			trace("OSC Connection established", toString());
		}
		private function onConnectError(e:OSCConnectionEvent):void {
			trace("OSC Connection error", toString());
		}
		private function onClose(e:OSCConnectionEvent):void {
			trace("OSC Connection Closed", toString());
		}
		private function onPacketIn(e:OSCConnectionEvent):void {
			mAq.quit();
		
			var input:Array = String(e.data.data).split(",");
			
			//	var input:Array = [ Math.floor(Math.random()*100),Math.floor(Math.random()*100) ];
			var dataLeft:Input = Input(OscData.data(input[0], input[1]));
			var dataRight:Input = Input(OscData.data(input[2], input[3]));
		
			//Yalog.debug(input.toString(), toString());
			if (dataLeft.pitch > 0) {
				var leftNewY:Number = DEFAULT_Y_VALUE_PAD - dataLeft.pitch + 160;
				var leftNewScaleY:Number = (dataLeft.amplitude / 80);
			
				//		mPadPlayerOne.y = leftNewY;
				mAq.addAsynchronousAction(new AQMove().move(mPadPlayerOne, 0.01, Number.NaN, Number.NaN, Number.NaN, leftNewY, Linear.easeOut));
				mAq.addAsynchronousAction(new AQScale().scale(mPadPlayerOne, 0.01, Number.NaN, Number.NaN, Number.NaN, leftNewScaleY, Linear.easeOut));
			}
			
			if (dataRight.pitch > 0) {
				var rightNewY:Number = DEFAULT_Y_VALUE_PAD - dataRight.pitch + 160;
				var rightNewScaleY:Number = (dataRight.amplitude / 80);
				
				//mPadPlayerTwo.y = rightNewY;
				mAq.addAsynchronousAction(new AQMove().move(mPadPlayerTwo, 0.01, Number.NaN, Number.NaN, Number.NaN, rightNewY, Linear.easeOut));
				mAq.addAsynchronousAction(new AQScale().scale(mPadPlayerTwo, 0.01, Number.NaN, Number.NaN, Number.NaN, rightNewScaleY, Linear.easeOut));
			}
			
			mAq.run();
		}
		private function updateScore(e:GameEvent):void {
			switch (e.player) {
				case "left":
					updatePlayerScore(mCounterRight);
					break;
				case "right":
					updatePlayerScore(mCounterLeft);
					break;
			}			;
			
			function updatePlayerScore( lr:TextField ):void {
				var d:int = int(lr.text);
				d++;
				lr.text = ScoreFormat.encode(d, 2);
			}
		}
	}
}
