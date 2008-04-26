package voicetrainer.utils {	import voicetrainer.data.vo.NoteData;		/**
	 *	Copyright 2008 Base 42 
	 *	@author Jankees van Woezik
	 *  date: Jan 22, 2008
	 */
	public class NoteHelper {				private var mArray:Array;		private var mNearestIndex:Number;				public function NoteHelper() {			mArray = new Array();			mArray.push(new NoteData("C", -1, 8.1757989156));			mArray.push(new NoteData("Db", -1, 8.6619572180));  			mArray.push(new NoteData("D", -1, 9.1770239974));   			mArray.push(new NoteData("Eb", -1, 9.7227182413));  			mArray.push(new NoteData("E", -1, 10.3008611535));   			mArray.push(new NoteData("F", -1, 10.9133822323));  			mArray.push(new NoteData("Gb", -1, 11.5623257097));   			mArray.push(new NoteData("G", -1, 12.2498573744));   			mArray.push(new NoteData("Ab", -1, 12.9782717994));   			mArray.push(new NoteData("A", -1, 13.7500000000));   			mArray.push(new NoteData("Bb", -1, 14.5676175474));   			mArray.push(new NoteData("B", -1, 15.4338531643));   			mArray.push(new NoteData("C", 0, 16.3515978313));   			mArray.push(new NoteData("Db", 0, 17.3239144361));   			mArray.push(new NoteData("D", 0, 18.3540479948));   			mArray.push(new NoteData("Eb", 0, 19.4454364826));   			mArray.push(new NoteData("E", 0, 20.6017223071));   			mArray.push(new NoteData("F", 0, 21.8267644646));   			mArray.push(new NoteData("Gb", 0, 23.1246514195));   			mArray.push(new NoteData("G", 0, 24.4997147489));   			mArray.push(new NoteData("Ab", 0, 25.9565435987));   			mArray.push(new NoteData("A", 0, 27.5000000000));   			mArray.push(new NoteData("Bb", 0, 29.1352350949));   			mArray.push(new NoteData("B", 0, 30.8677063285));   			mArray.push(new NoteData("C", 1, 32.7031956626));			mArray.push(new NoteData("Db", 1, 34.6478288721));			mArray.push(new NoteData("D", 1, 36.7080959897));			mArray.push(new NoteData("Eb", 1, 38.8908729653));			mArray.push(new NoteData("E", 1, 41.2034446141));			mArray.push(new NoteData("F", 1, 43.6535289291));			mArray.push(new NoteData("Gb", 1, 46.2493028390));			mArray.push(new NoteData("G", 1, 48.9994294977));			mArray.push(new NoteData("Ab", 1, 51.9130871975));			mArray.push(new NoteData("A", 1, 55.0000000000));			mArray.push(new NoteData("Bb", 1, 58.2704701898));			mArray.push(new NoteData("B", 1, 61.7354126570));			mArray.push(new NoteData("C", 2, 65.4063913251));  			mArray.push(new NoteData("Db", 2, 69.2956577442));   			mArray.push(new NoteData("D", 2, 73.4161919794));   			mArray.push(new NoteData("Eb", 2, 77.7817459305));   			mArray.push(new NoteData("E", 2, 82.4068892282));   			mArray.push(new NoteData("F", 2, 87.3070578583));   			mArray.push(new NoteData("Gb", 2, 92.4986056779));   			mArray.push(new NoteData("G", 2, 97.9988589954));   			mArray.push(new NoteData("Ab", 2, 103.8261743950));  			mArray.push(new NoteData("A", 2, 110.0000000000));  			mArray.push(new NoteData("Bb", 2, 116.5409403795));  			mArray.push(new NoteData("B", 2, 123.4708253140));  			mArray.push(new NoteData("C", 3, 130.8127826503));    			mArray.push(new NoteData("Db", 3, 138.5913154884));    			mArray.push(new NoteData("D", 3, 146.8323839587));    			mArray.push(new NoteData("Eb", 3, 155.5634918610));    			mArray.push(new NoteData("E", 3, 164.8137784564));    			mArray.push(new NoteData("F", 3, 174.6141157165));    			mArray.push(new NoteData("Gb", 3, 184.9972113558));    			mArray.push(new NoteData("G", 3, 195.9977179909));    			mArray.push(new NoteData("Ab", 3, 207.6523487900));    			mArray.push(new NoteData("A", 3, 220.0000000000));    			mArray.push(new NoteData("Bb", 3, 233.0818807590));    			mArray.push(new NoteData("B", 3, 246.9416506281));    			mArray.push(new NoteData("C", 4, 261.6255653006));			mArray.push(new NoteData("Db", 4, 277.1826309769));			mArray.push(new NoteData("D", 4, 293.6647679174));			mArray.push(new NoteData("Eb", 4, 311.1269837221));			mArray.push(new NoteData("E", 4, 329.6275569129));			mArray.push(new NoteData("F", 4, 349.2282314330));			mArray.push(new NoteData("Gb", 4, 369.9944227116));			mArray.push(new NoteData("G", 4, 391.9954359817));			mArray.push(new NoteData("Ab", 4, 415.3046975799));			mArray.push(new NoteData("A", 4, 440.0000000000));			mArray.push(new NoteData("Bb", 4, 466.1637615181));			mArray.push(new NoteData("B", 4, 493.8833012561));			mArray.push(new NoteData("C", 5, 523.2511306012));   			mArray.push(new NoteData("Db", 5, 554.3652619537));   			mArray.push(new NoteData("D", 5, 587.3295358348));   			mArray.push(new NoteData("Eb", 5, 622.2539674442));   			mArray.push(new NoteData("E", 5, 659.2551138257));   			mArray.push(new NoteData("F", 5, 698.4564628660));   			mArray.push(new NoteData("Gb", 5, 739.9888454233));   			mArray.push(new NoteData("G", 5, 783.9908719635));   			mArray.push(new NoteData("Ab", 5, 830.6093951599));   			mArray.push(new NoteData("A", 5, 880.0000000000));   			mArray.push(new NoteData("Bb", 5, 932.3275230362));   			mArray.push(new NoteData("B", 5, 987.7666025122));   			mArray.push(new NoteData("C", 6, 1046.5022612024)); 			mArray.push(new NoteData("Db", 6, 1108.7305239075)); 			mArray.push(new NoteData("D", 6, 1174.6590716696)); 			mArray.push(new NoteData("Eb", 6, 1244.5079348883)); 			mArray.push(new NoteData("E", 6, 1318.5102276515)); 			mArray.push(new NoteData("F", 6, 1396.9129257320)); 			mArray.push(new NoteData("Gb", 6, 1479.9776908465)); 			mArray.push(new NoteData("G", 6, 1567.9817439270)); 			mArray.push(new NoteData("Ab", 6, 1661.2187903198)); 			mArray.push(new NoteData("A", 6, 1760.0000000000)); 			mArray.push(new NoteData("Bb", 6, 1864.6550460724)); 			mArray.push(new NoteData("B", 6, 1975.5332050245)); 			mArray.push(new NoteData("C", 7, 2093.0045224048));			mArray.push(new NoteData("Db", 7, 2217.4610478150));			mArray.push(new NoteData("D", 7, 2349.3181433393));			mArray.push(new NoteData("Eb", 7, 2489.0158697766));			mArray.push(new NoteData("E", 7, 2637.0204553030));			mArray.push(new NoteData("F", 7, 2793.8258514640));			mArray.push(new NoteData("Gb", 7, 2959.9553816931));			mArray.push(new NoteData("G", 7, 3135.9634878540));			mArray.push(new NoteData("Ab", 7, 3322.4375806396));			mArray.push(new NoteData("A", 7, 3520.0000000000));			mArray.push(new NoteData("Bb", 7, 3729.3100921447));			mArray.push(new NoteData("B", 7, 3951.0664100490));			mArray.push(new NoteData("C", 8, 4186.0090448096));			mArray.push(new NoteData("Db", 8, 4434.9220956300)); 			mArray.push(new NoteData("D", 8, 4698.6362866785)); 			mArray.push(new NoteData("Eb", 8, 4978.0317395533)); 			mArray.push(new NoteData("E", 8, 5274.0409106059)); 			mArray.push(new NoteData("F", 8, 5587.6517029281)); 			mArray.push(new NoteData("Gb", 8, 5919.9107633862)); 			mArray.push(new NoteData("G", 8, 6271.9269757080)); 			mArray.push(new NoteData("Ab", 8, 6644.8751612791));			mArray.push(new NoteData("A", 8, 7040.0000000000));			mArray.push(new NoteData("Bb", 8, 7458.6201842894));			mArray.push(new NoteData("B", 8, 7902.1328200980));			mArray.push(new NoteData("C", 8, 8372.0180896192));			mArray.push(new NoteData("Db", 8, 8869.8441912599));			mArray.push(new NoteData("D", 8, 9397.2725733570));			mArray.push(new NoteData("Eb", 8, 9956.0634791066));			mArray.push(new NoteData("E", 8, 10548.0818212118));			mArray.push(new NoteData("F", 8, 11175.3034058561));			mArray.push(new NoteData("Gb", 8, 11839.8215267723));			mArray.push(new NoteData("G", 8, 12543.8539514160));		}				public function  getPitchByNoteAndOctave(inNote:String,inOctave:int):NoteData {			for (var i:Number = 0;i<mArray.length; i++) {				var data:NoteData = NoteData(mArray[i]);				if(data.isValidNote(inNote)&&data.isValidOctave(inOctave)) return data;			}			return null;		}				public function getNearestNoteByPitch(inPitch:Number):NoteData {			var mNearestNote:NoteData = NoteData(mArray[0]);			var mNearestDiff:Number = 100000;						for (var i:Number = 0;i<mArray.length; i++) {				var currentNote:NoteData = NoteData(mArray[i]);				var diff:Number = currentNote.note_pitch - inPitch;				if(Math.abs(diff)<mNearestDiff) {					mNearestNote = currentNote;						mNearestIndex = i;					mNearestDiff = Math.abs(diff);				}			}						return mNearestNote;			}						public function getNearestIndexByPitch(inPitch:Number):Number {			getNearestNoteByPitch(inPitch);			return mNearestIndex;			}										public function toString():String {			return "voicetrainer.utils.NoteHelper";		}	}}