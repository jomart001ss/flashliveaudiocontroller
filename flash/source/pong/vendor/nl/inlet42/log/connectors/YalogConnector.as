/**
 *   
 *  This file is part of AS3FlashProject.
 *
 *  AS3FlashProject is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License.
 *
 *  AS3FlashProject is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with AS3FlashProject.  If not, see <http://www.gnu.org/licenses/>.
 *  
 *  For more information contact one of the authors at www.inlet42.nl;
 *  
 */
package nl.inlet42.log.connectors 
{
	import nl.acidcats.yalog.Yalog;
	import nl.inlet42.log.BaseLogger;
	import nl.inlet42.log.ILogger;

	public class YalogConnector extends BaseLogger implements ILogger 
	{

		public function init() : void 
		{
		}

		public function sendDebug(...args) : void 
		{
			Yalog.debug(String(args), getSender());
		}

		public function sendInfo(...args) : void 
		{
			Yalog.info(String(args), getSender());
		}

		public function sendNotice(...args) : void 
		{
			Yalog.info(String(args), getSender());
		}

		public function sendWarning(...args) : void 
		{
			Yalog.error(String(args), getSender());
		}

		public function sendError(...args) : void 
		{
			Yalog.error(String(args), getSender());
		}

		public function sendFatal(...args) : void 
		{
			Yalog.fatal(String(args), getSender());
		}

		public function sendCritical(...args) : void 
		{
			Yalog.error(String(args), getSender());
		}

		public function sendStatus(...args) : void 
		{
			Yalog.debug(String(args), getSender());
		}
	}
}
