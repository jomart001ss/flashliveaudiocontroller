package voicetrainer.ui {	import flash.display.Sprite;	import flash.text.TextField;	import voicetrainer.data.vo.InputData;	import voicetrainer.utils.NoteHelper;		/**
	 *	Copyright 2008 Base 42 
	 *	@author Jankees van Woezik
	 *  date: Jan 23, 2008
	 */
	public class HarmonicController extends Sprite {		private var mRightInput:InputData;		private var mLeftInput:InputData;		private var mNotehelper:NoteHelper;		public var diff_tf:TextField;		public function HarmonicController() {			trace("HarmonicController: ", toString());		}		override public function toString():String {			return "voicetrainer.ui.HarmonicController";		}	}}