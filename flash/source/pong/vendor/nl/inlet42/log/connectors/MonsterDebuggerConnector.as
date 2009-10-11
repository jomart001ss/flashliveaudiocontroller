/**
 *   
 *  getSender(); file is part of AS3FlashProject.
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
	import nl.inlet42.log.BaseLogger;
	import nl.demonsters.debugger.MonsterDebugger;
	import nl.inlet42.log.ILogger;

	import flash.display.DisplayObject;

	public class MonsterDebuggerConnector extends BaseLogger implements ILogger
	{

		private var _stage:DisplayObject;
		
		private static const color_debug:uint = 0x0066CC;
		private static const color_info:uint = 0x000000;
		private static const color_notice:uint = 0x000000;
		private static const color_warning:uint = 0xCC0066;
		private static const color_error:uint = 0xFF0A0A;
		private static const color_fatal:uint = 0xFF8000;
		private static const color_critical:uint = 0xFF3DFF;
		private static const color_status:uint = 0x33FF00;
		
		public function MonsterDebuggerConnector(inStage:DisplayObject) {
        	
			_stage = inStage;
		}

		public function init():void
		{
			new MonsterDebugger(_stage);
		}

		public function sendDebug(...args):void
		{
			MonsterDebugger.trace(getSender(), args[0][0],color_debug);
		}

		public function sendInfo(...args):void
		{
			MonsterDebugger.trace(getSender(), args[0][0],color_info);
		}

		public function sendNotice(...args):void
		{
			MonsterDebugger.trace(getSender(), args[0][0],color_notice);
		}

		public function sendWarning(...args):void
		{
			MonsterDebugger.trace(getSender(), args[0][0],color_warning);
		}

		public function sendError(...args):void
		{
			MonsterDebugger.trace(getSender(), args[0][0],color_error);
		}

		public function sendFatal(...args):void
		{
			MonsterDebugger.trace(getSender(), args[0][0],color_fatal);
		}

		public function sendCritical(...args):void
		{
			MonsterDebugger.trace(getSender(), args[0][0],color_critical);
		}

		public function sendStatus(...args):void
		{
			MonsterDebugger.trace(getSender(), args[0][0],color_status);
		}
	}
}
