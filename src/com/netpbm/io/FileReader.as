package com.netpbm.io
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	
	import mx.events.Request;
	
	/**
	 * FileReader.as
	 * 
	 * @author Cristobal Dabed
	 */ 
	public final class FileReader extends Reader
	{
		[Event(name="complete", type="flash.events.Event")]
		public static const COMPLETE:String = "complete";
		
		/**
		 * Constructor
		 * 
		 * @param file The url of the file to read either local to the swf or a valid filepath
		 */ 
		public function FileReader(file:String)
		{
			super();
			setup(file);
		}
		
		/**
		 * @private
		 * 	The loader that loades the contents of the specified file
		 */ 
		private var loader:URLStream;
		
		/**
		 * @private
		 *  
		 */
		private var request:URLRequest;
		
		
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

		}
		
		/**
		 * Load
		 */ 
		public function load():void
		{
			loader.load(request);
		}
		
		/**
		 * @override
		 */ 
		override public function dispose():void
		{
			loader  = null;
			request = null;
			super.dispose();
		}
		
		//--------------------------------------
		//
		// Events
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
			// forward the event
			dispatchEvent(event);
		}
		
		/**
		 * Handle security error
		 * 
		 * @param error
		 */		
		private function handleIOError(event:IOErrorEvent):void
		{
			trace("IOError", event);
		}
		
		/**
		 * Handle security error
		 * 
		 * @param error
		 */ 
		private function handleSecurityError(event:SecurityErrorEvent):void
		{
			trace("SecurityError", event);
			
		}
	}
}