package voicetrainer.data.vo {	import voicetrainer.data.vo.IntervalNameData;		/**
	 *	Copyright 2008 Base 42 
	 *	@author Jankees van Woezik
	 *  date: Jan 23, 2008
	 */
	public class GameStateData {		public var state_name:String;		public var state_interval:IntervalNameData;						public function GameStateData(inName:String,inInterval:IntervalNameData) {			state_name = inName;			state_interval = inInterval;		}	}}