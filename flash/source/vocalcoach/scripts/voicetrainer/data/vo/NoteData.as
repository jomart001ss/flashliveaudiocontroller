package voicetrainer.data.vo {	/**
	 *	Copyright 2008 Base 42 
	 *	@author Jankees van Woezik
	 *  date: Jan 22, 2008
	 */
	public class NoteData {		public var note_note:String;		public var note_octave:int;		public var note_pitch:Number;				public function NoteData (inNote:String,inOctave:int,inPitch:Number) : void {			note_note = inNote;			note_octave = inOctave;			note_pitch = inPitch;		}				public function isValidNote(inNote:String):Boolean{			if(inNote==note_note) return true;			//else			return false;		}		public function isValidOctave(inOctave:int):Boolean{			if(inOctave==note_octave) return true;			//else			return false;		}		public function isValidPitch(inPitch:Number):Boolean{			if(inPitch==note_pitch) return true;			//else			return false;		}			}}