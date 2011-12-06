package com.netpbm.events
{
	import flash.events.Event;
	
	public class NetPBMEvent extends Event
	{
		public static const IMAGE_LOADED:String = "imageLoaded";
		
		public function NetPBMEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}