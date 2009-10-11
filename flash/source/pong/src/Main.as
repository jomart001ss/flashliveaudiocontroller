package  
{
	import nl.inlet42.log.Logger;
	import nl.inlet42.log.connectors.TrazzleConnector;

	import flash.display.MovieClip;

	/**
	 *	@author Jankees.van.Woezik
	 */
	public class Main extends MovieClip
	{

		public function Main() 
		{
			Logger.addLogger(new TrazzleConnector());

			Logger.debug("Main: ");
		}
	}
}
