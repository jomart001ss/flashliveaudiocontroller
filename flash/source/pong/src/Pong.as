package  
{
	import fla.Background;

	import it.h_umus.osc.OSCConnection;
	import it.h_umus.osc.OSCConnectionEvent;

	import nl.inlet42.log.Logger;
	import nl.inlet42.log.connectors.TrazzleConnector;

	import flash.display.MovieClip;

	/**
	 *	@author Jankees.van.Woezik (base42.nl)
	 *	@author Patrick.Brouwer (base42.nl)
	 *	@version 2.0
	 */
	public class Pong extends MovieClip
	{

		private var _osc:OSCConnection;

		public function Pong() 
		{
			Logger.addLogger(new TrazzleConnector());
			
			addChild(new Background());
			
			_osc = new OSCConnection();
			_osc.connect("127.0.0.1", 3000);
			_osc.addEventListener(OSCConnectionEvent.OSC_PACKET_IN,handlePacket);
			
			Logger.debug("Main: ");
			Logger.debug("Main: ");
		}

		private function handlePacket(event:OSCConnectionEvent):void
		{
			Logger.debug("handlePacket: " + event);
		}
	}
}
