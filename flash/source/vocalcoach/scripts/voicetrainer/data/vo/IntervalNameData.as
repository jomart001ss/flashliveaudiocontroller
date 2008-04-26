package voicetrainer.data.vo {		/**
	 *	Copyright 2008 Base 42 
	 *	@author Jankees van Woezik
	 *  date: Jan 23, 2008	 *  	 *  note: this is for use with the Array in the NoteHelper class
	 */
	public class IntervalNameData {				public var interval_name:String;		public var interval_indexdistance:Number;						public function IntervalNameData(inName:String, inIntervalIndex:Number) {			interval_indexdistance = inIntervalIndex;			interval_name = inName;		}	}}