package brick
{
	import fla.brick.Background;

	import nl.inlet42.log.Logger;
	import nl.inlet42.log.connectors.TrazzleConnector;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 *	@author Jankees.van.Woezik (base42.nl)
	 *	@author Patrick.Brouwer (base42.nl)
	 *	@version 2.0
	 */
	public class Brick extends MovieClip
	{

		private var _holder : Sprite;
		
		public function Brick() 
		{
			Logger.addLogger(new TrazzleConnector());
			addChild(new Background());
			
			_holder = new Sprite();
			addChild(_holder);
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0xff0000);
			sp.graphics.drawRect(0, 0, 10, 10);
			sp.graphics.endFill();
			
			_holder.addChild(sp);
			
			drawStones();
			
			
		}
		
		private function drawStones() : void
		{
			
		}
	}
}
