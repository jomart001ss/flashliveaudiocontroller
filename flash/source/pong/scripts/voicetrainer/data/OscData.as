package voicetrainer.data {

	public class OscData {
		
		public static function data( p:Number, a:Number ) : Object {
			var obj:Input = new Input();
			obj.pitch = p;
			obj.amplitude = a;
			
			return obj;
		}
	}
	
	
}
