package brick 
{
	import flash.display.Sprite;

	/**
	 *	@author Jankees.van.Woezik
	 */
	public class Block extends Sprite 
	{

		public static const WIDTH:Number = 32;
		public static const HEIGHT:Number = 15;
		private var _strength:uint;

		public function Block(inColorNumber:uint = 0)
		{
			var color:uint = 0x1df727;
			
			switch (inColorNumber) 
			{
				case 1:
					color = 0xbbbcbb;
					break;
				case 2:
					color = 0xfe2517;
					break;
				case 3:
					color = 0xfff830;
					break;
				case 4:
					color = 0x0f9efc;
					break;
				case 5:
					color = 0x1df727;
					break;
			}
			
			_strength = inColorNumber;
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(color);
			sp.graphics.drawRect(0,0,WIDTH,HEIGHT);
			sp.graphics.endFill();
			addChild(sp);
		}

		public function hittest(inBall:Sprite):Boolean
		{
			if(!inBall.hitTestObject(this)) return false;
			
			_strength -= 1;
			if(_strength <= 0) parent.removeChild(this);
			return true;
		}

		override public function toString():String 
		{
			return "Block with a remaining strength of: " + _strength;
		}
	}
}
