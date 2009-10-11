package pong
{
	import nl.inlet42.log.Logger;
	import nl.inlet42.log.connectors.TrazzleConnector;

	import voice.VoiceConnection;
	import voice.VoiceDataEvent;

	import flash.display.MovieClip;

	/**
	 *	@author Jankees.van.Woezik (base42.nl)
	 *	@author Patrick.Brouwer (base42.nl)
	 *	@version 2.0
	 */
	public class Pong extends MovieClip
	{

		private var _voice:VoiceConnection;

		public function Pong() 
		{
			Logger.addLogger(new TrazzleConnector());
			
			_voice = new VoiceConnection();
			_voice.addEventListener(VoiceDataEvent._EVENT,handleVoiceEvents);
		}
		
		private function handleVoiceEvents(event:VoiceDataEvent):void
		{
			Logger.debug("handleVoiceEvents: " + event.data);
		}
	}
}
