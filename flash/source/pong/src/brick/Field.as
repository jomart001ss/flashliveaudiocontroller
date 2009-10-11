package brick 
{
	import flash.display.Sprite;

	/**
	 *	@author Jankees.van.Woezik
	 */
	public class Field extends Sprite 
	{

		private var _levelNumber:Number;

		public function Field(inLevelNumber:Number)
		{
			_levelNumber = inLevelNumber;

			var leni:uint = BrickLevel.WIDTH / (Block.WIDTH + 5);
			for (var i:uint = 0;i < leni;i ++) 
			{
				var lenj:uint = 5;
				for (var j:uint = 0;j < lenj;j ++) 
				{
					var block:Block = new Block(5 - j);
					block.x = i * (Block.WIDTH + 5); 
					block.y = j * (Block.HEIGHT + 5); 
					addChild(block);
				}
			}
		
			x = (BrickLevel.WIDTH - width) / 2;
			y = 15;
		}

		public function hitTest(inBall:Sprite):void
		{
			var child:Block;
			var leni:uint = numChildren;
			for (var i:uint = 0;i < leni;i ++) 
			{
				try 
				{
					child = Block(getChildAt(i));
					child.hittest(inBall);
				} catch (e:Error) 
				{
					// a object has been removed so there is one i to much
				}
			}
		}
	}
}
