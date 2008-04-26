package voicetrainer.utils {

	public class ScoreFormat {
		
		public static function encode(score:int, nums:int):String {
			var l:int = String(score).length;
			var s:String = new String();
			for (var i:int=l;i<nums;i++) s += "0";
			s += score;
			return s;
		}
		
	}
}
