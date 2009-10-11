package pong 
{
	import fla.pong.Pad;

	import flash.events.MouseEvent;

	/**
	 *	@author Jankees.van.Woezik
	 */
	public class PongPad extends Pad
	{
		public function PongPad() {
			addEventListener(MouseEvent.MOUSE_DOWN,handleDown);
			addEventListener(MouseEvent.MOUSE_UP,handleUp);
		}
		
		private function handleUp(event:MouseEvent):void
		{
			stopDrag();
		}

		private function handleDown(event:MouseEvent):void
		{
			startDrag();
		}
	}
}
