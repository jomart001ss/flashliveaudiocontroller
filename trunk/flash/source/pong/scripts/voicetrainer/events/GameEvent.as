package voicetrainer.events {
	
	import flash.events.Event;

	public class GameEvent extends Event {
		/** Event type. */
		public static const SCORED:String = "onScored";
		
		public var player:String;
		
		public function GameEvent(	type:String,
									bubbles:Boolean = false,
									cancelable:Boolean = false,
									player:String = "") {	
										
			super(type, bubbles, cancelable);
			this.player = player;
		}

		public override function clone() : Event {
			return new GameEvent(type, bubbles, cancelable, player);
		}
		
		public override function toString() : String {
			return formatToString("GameEvent", "type", "bubbles", "cancelable", "eventPhase", "player");
		}
	}
}
