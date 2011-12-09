package com.netpbm.events
{
	import flash.events.Event;
	
	/**
	 * NetPBMErrorEvent.as
	 * 
	 * @author Cristobal Dabed
	 */ 
	public final class NetPBMErrorEvent extends Event
	{
		/**
		 * NetPBMErrorEvent
		 */ 
		public function NetPBMErrorEvent(type:String, error:Error, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this._error = error;
		}
		
		/**
		 * @private
		 */ 
		private var _error:Error;
		
		/**
		 * @readonly error
		 */ 
		public function get error():Error
		{
			return _error;
		}
		
		/**
		 * @override
		 */ 
		override public function clone():Event
		{
			return new NetPBMErrorEvent(type, error, bubbles, cancelable);
		}
	}
}