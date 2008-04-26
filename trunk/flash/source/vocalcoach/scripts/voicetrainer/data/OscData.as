package voicetrainer.data {
	import voicetrainer.data.vo.InputData;
	public class OscData {
		
		public var mData:InputData;
		
		public function setData( p:Number, a:Number ) : InputData {
			var obj:InputData = new InputData();
			obj.pitch = p;
			obj.amplitude = a;
			mData = obj;
			return mData;
		}
		
		public function getData():InputData{
			return mData;	
		}
	}
	
	
}
