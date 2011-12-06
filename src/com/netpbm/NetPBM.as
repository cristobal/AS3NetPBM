package com.netpbm
{
	import com.netpbm.decoder.NetPBMDecoder;
	import com.netpbm.decoder.PBMDecoder;
	import com.netpbm.events.NetPBMEvent;
	
	import com.netpbm.io.FileReader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	[Event(name="imageLoaded", type="com.netpbm.events.NetPBMEvent")]
	
	// TODO: Add support for writing to file.
	/**
	 * NetPBM.as
	 * 
	 * @author Cristobal Dabed
	 * @version {{VERSION_NUMBER}}
	 */ 
	public final class NetPBM extends EventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		public static const PORTABLE_BITMAP_ASCII:String  	= "P1";
		public static const PORTABLE_GRAYMAP_ASCII:String	= "P2";
		public static const PORTABLE_PIXMAP_ASCII:String	= "P3";
		public static const PORTABLE_BITMAP_BINARY:String 	= "P4";
		public static const PORTABLE_GRAYMAP_BINARY:String 	= "P5";
		public static const PORTABLE_PIXMAP_BINARY:String 	= "P6";
		
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------	
		/**
		 * @private
		 */ 
		private static var extRe:RegExp = /\.(pbm|pgm|ppm)$/i;
		
		/**
		 * @private
		 */ 
		private static var timerDelay:uint = 250;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */ 
		public function NetPBM(target:IEventDispatcher=null)
		{
			super(target);
			setup();
		}
		
		
		//--------------------------------------
		//
		// Variables
		//
		//--------------------------------------
		
		/**
		 * @private
		 */ 
		private var fileReader:FileReader;
		 
		/**
		 * @private
		 */ 
		private var timer:Timer;
		
		/**
		 * @private
		 */ 
		private var _data:BitmapData;
		
		/**
		 * @readonly data
		 */ 
		public function get data():BitmapData
		{
			return _data;
		}
		
		/**
		 * Set data
		 */ 
		private function setData(value:BitmapData):void
		{
			_data = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Setup
		 */ 
		private function setup():void
		{
			timer = new Timer(timerDelay);
			timer.addEventListener(TimerEvent.TIMER, handleTimer);
		}
		
		/**
		 * Read image
		 * 
		 * @param filename 
		 */ 
		public function readImage(filename:String):void 
		{
/*			fileReader = new FileReader(filename);
			timer.start();*/
		}
		
		/**
		 * Decode image
		 */ 
		private function decodeImage():void
		{
/*			var reader:BufferedReader = new BufferedReader(fileReader);
			var line:String = reader.readLine();
			var decoder:NetPBMDecoder = null;
			switch(line) {
				case PORTABLE_BITMAP_ASCII:
				case PORTABLE_BITMAP_BINARY:
				{
					decoder = new PBMDecoder();
					break;
				}
			}
			
			if (decoder) {
				var data:BitmapData = decoder.decode( new BufferedReader(fileReader) );
				if (data) {
					setData(data);
					dispatchEvent(new NetPBMEvent(NetPBMEvent.IMAGE_LOADED));
				} 
				else {
					throw new Error("The file could not be decoded");
				}
			}
			else {
				throw new Error("The file to be read is not one of the NetBMP type.");
			}*/
		}
		
		/**
		 * Handle timer
		 * 
		 * @param event
		 */ 
		private function handleTimer(event:Event):void
		{
/*			if (fileReader.ready()) {
				timer.stop();
				decodeImage();
				
			}*/
		}
	}
}
