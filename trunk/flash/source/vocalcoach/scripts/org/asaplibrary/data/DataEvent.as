package org.asaplibrary.data {
	import flash.events.Event;

	/**
	 *	Copyright (c) 2007 Lost Boys 
	 *	@author stephan.bezoen
	 *	
	 */
	 
	 public class DataEvent extends Event {
		/** Generic event type */
		public static var EVENT_DATA:String = "onDataEvent";
		
		/** subtype of event sent when loading and parsing went ok */
		public static var LOADED:String = "onDataLoaded";
		/** subtype of event sent when there was an error loading the data */
		public static var LOAD_ERROR:String = "onDataLoadError";
		/** subtype of event sent when there was an error parsing the data */
		public static var PARSE_ERROR:String = "onDataParseError";
		
		/** subtype of event */
		public var subtype:String;
		/** name of original request*/
		public var name:String;
		/** error message if available */
		public var error:String;
		/** if possible, a single array of typed data objects */
		public var data:Array;
		
		
		function DataEvent(inType : String, inName:String, inData:Array) {
			super(EVENT_DATA);
			
			subtype = inType;
			name = inName;
			data = inData;
		}

	}
}