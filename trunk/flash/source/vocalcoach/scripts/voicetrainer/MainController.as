package voicetrainer {
	import org.asaplibrary.management.movie.LocalController;
	import org.fwiidom.osc.OSCConnection;
	import org.fwiidom.osc.OSCConnectionEvent;

	import voicetrainer.controllers.GameController;
	import voicetrainer.data.OscData;
	import voicetrainer.data.vo.InputData;	

	public class MainController extends LocalController {
		private static const STR_LOCAL_IP:String = "127.0.0.1";
		private static const NUM_PORT:int = 3000;
		private var mOSC:OSCConnection;
		private var mGameController:GameController;

		public function MainController() {
			createUI();
		}

		private function createUI():void {
			initUI();
		}

		private function initUI():void {
			// OSC events
			mOSC = new OSCConnection(STR_LOCAL_IP, NUM_PORT);
			mOSC.addEventListener(OSCConnectionEvent.ON_CONNECT, onConnect);
			mOSC.addEventListener(OSCConnectionEvent.ON_CONNECT_ERROR, onConnectError);
			mOSC.addEventListener(OSCConnectionEvent.ON_PACKET_IN, onPacketIn);
			mOSC.addEventListener(OSCConnectionEvent.ON_CLOSE, onClose);
			mOSC.connect();

			mGameController = new GameController(this);
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
			
			
			var inData:Array = String(e.data.data).split(",");
			
			var dataLeft:InputData = InputData(new OscData().setData(inData[0], inData[1]));
			var dataRight:InputData = InputData(new OscData().setData(inData[2], inData[3]));

			if(dataLeft.amplitude != 0 && dataRight.amplitude != 0) mGameController.setInputNotes(dataLeft, dataRight);
		}
	}
}
