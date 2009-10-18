package brick
{
	import flash.events.Event;
	import fla.brick.Background;

	import voice.BaseVoiceApplication;
	import voice.VoiceDataEvent;

	import flash.display.Sprite;

	/**
	 *	@author Jankees.van.Woezik (base42.nl)
	 *	@author Patrick.Brouwer (base42.nl)
	 *	@version 2.0
	 */
	public class Brick extends BaseVoiceApplication
	{

		private var _holder : Sprite;
		private var _game : BrickLevel;

		public function Brick() 
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}
		
		private function removedFromStage(event : Event) : void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			if (_game)
			{
				_game = null;
			}
		}

		private function addedToStage(event : Event) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addChild(new Background());
			
			_holder = new Sprite();
			_holder.x = _holder.y = 95;
			addChild(_holder);
			
			createLevel(0);
		}

		private function createLevel(levelNum : int) : void
		{
			if (_game)
			{
				_holder.removeChild(_game);
				_game = null;
			}
			
			_game = new BrickLevel(levelNum);
			_holder.addChild(_game);
		}

		override protected function handleVoiceEvents(event : VoiceDataEvent) : void
		{
			if (_game)
			{
				_game.input(event.data);
			}
		}
	}
}
