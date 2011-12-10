package com.netpbm.net
{
	
	import com.netpbm.decoder.NetPBMDecoder;
	import com.netpbm.events.NetPBMErrorEvent;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	/**
	 * @Event complete
	 */
	[Event(name="complete", type="flash.events.Event")]

	/**
	 * @Event ioError
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]

	/**
	 * @Event securityError
	 */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	/**
	 * @Event errorEvent
	 */
	[Event(name="errorEvent", type="com.netpbm.events.NetPBMErrorEvent")]
	
	/**
	 * NetPBMLoader.as
	 * 
	 * @author Cristobal Dabed
	 * @version {{VERSION_NUMBER}}
	 */ 
	public final class NetPBMLoader extends EventDispatcher
	{
		
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @public
		 */ 
		public static const DECODING_ERROR:String = "decodingError";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */ 
		public function NetPBMLoader(file:String)
		{
			super();
			setup(file);
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */ 
		private var loader:URLStream;
		
		/**
		 * @private
		 */ 
		private var request:URLRequest;
		
		/**
		 * @private
		 */ 
		private var bytes:ByteArray;
		
		/**
		 * @public
		 */ 
		public var bitmapData:BitmapData;
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Setup
		 * 
		 * @param file
		 */ 
		private function setup(file:String):void
		{
			loader = new URLStream();
			
			loader.addEventListener(ProgressEvent.PROGRESS, handleProgress);
			loader.addEventListener(Event.COMPLETE, handleComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			
			request = new URLRequest(file);
			
			bytes = new ByteArray();
		}
		
		/**
		 * Load image
		 * 
		 * @param image The url for an image
		 */ 
		public function load():void
		{
			trace("");
			loader.load(request);
		}
		
		/**
		 * Dispose (garbage collect)
		 */ 
		public function dispose():void
		{
			if (bitmapData) {
				bitmapData.dispose();
				bitmapData = null;
			}
		}
		
		/**
		 * Garbage collect
		 */ 
		private function gc():void
		{
			if (bytes) {
				bytes.clear();
				bytes = null;
			}
			
			loader.removeEventListener(ProgressEvent.PROGRESS, handleProgress);
			loader.removeEventListener(Event.COMPLETE, handleComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			
			
			loader = null;
			request = null;
		}
		
		
		//--------------------------------------
		//
		// URlStream Events
		//
		//--------------------------------------
		
		/**
		 * Handle urlStream progress
		 * 
		 * @param event
		 */ 
		private function handleProgress(event:ProgressEvent):void
		{			
			if (loader.bytesAvailable > 0) {
				loader.readBytes(
					bytes, bytes.length
				);
			}
		}
		
		/**
		 * Handle urlStream complete
		 */ 
		private function handleComplete(event:Event):void
		{
			try {
				var time:int = getTimer();
				bitmapData = NetPBMDecoder.decode(bytes);
				trace("decoding done in", getTimer() - time,"ms");
				// forward event
				dispatchEvent(event);	
			}
			catch (error:Error) {
				
				// decoding error either invalid format or data is corrupt
				var errorEvent:NetPBMErrorEvent = new NetPBMErrorEvent(DECODING_ERROR, error);
				dispatchEvent(event);
			}
			
			// Garbage collect
			gc();
		}
		
		/**
		 * Handle security error
		 * 
		 * @param error
		 */		
		private function handleIOError(event:IOErrorEvent):void
		{
			// forward the event
			dispatchEvent(event);
			
			// Garbage collect
			gc();	
		}
		
		/**
		 * Handle security error
		 * 
		 * @param error
		 */ 
		private function handleSecurityError(event:SecurityErrorEvent):void
		{
			// forward the event
			dispatchEvent(event);
			
			// Garbage collect
			gc();
		}
		
	}
}