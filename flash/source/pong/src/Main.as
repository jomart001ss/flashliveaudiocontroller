package  
{
	import flash.net.URLRequest;
	import nl.inlet42.log.Logger;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author Patrick Brouwer [patrick at inlet dot nl]
	 */
	public class Main extends Sprite 
	{
		
		public static const GAME_PONG:String = "pong.swf";
		public static const GAME_BRICK:String = "brick.swf";
		
		private var _game : String;
		private var _loader : Loader;

		public function Main()
		{
			_game = GAME_PONG;
			_loader = new Loader();
			addChild(_loader);
			
			stage.addEventListener(MouseEvent.CLICK, switchGame);
			loadGame();
		}

		private function switchGame(event : MouseEvent) : void
		{
			_game = _game == GAME_PONG ? GAME_BRICK : GAME_PONG;
			loadGame();
		}

		private function loadGame() : void
		{
			_loader.unload();
			try {
				_loader.load(new URLRequest(_game));
			} catch (ei:Error) {
			}
		}
	}
}
