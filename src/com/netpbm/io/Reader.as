package com.netpbm.io
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	public class Reader extends EventDispatcher
	{
		public function Reader()
		{
			super();
		}
		
		/**
		 * @private
		 */ 
		protected var bytes:ByteArray = new ByteArray();
		
		/**
		 * Dispose
		 */ 
		public function dispose():void
		{
			bytes.clear();
			bytes = null;
		}
	}
}