package voice 
{
	import nl.inlet42.log.Logger;
	import nl.inlet42.log.connectors.TrazzleConnector;

	import flash.display.Sprite;

	/**
	 *	@author Jankees.van.Woezik
	 */
	public class BaseVoiceApplication extends Sprite 
	{

		private var _voice:VoiceConnection;
		
		protected var _voiceDataLeft:VoiceData;
		protected var _voiceDataRight:VoiceData;

		public function BaseVoiceApplication()
		{
			Logger.addLogger(new TrazzleConnector());
            
			_voice = new VoiceConnection();
			_voice.addEventListener(VoiceDataEvent._EVENT,handleVoiceEvents);
		}

		protected function handleVoiceEvents(event:VoiceDataEvent):void
		{
		}
	}
}
