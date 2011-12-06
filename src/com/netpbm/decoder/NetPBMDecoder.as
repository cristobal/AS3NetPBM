package com.netpbm.decoder
{
	
	import flash.display.BitmapData;

	public class NetPBMDecoder
	{
		/**
		 * @protected
		 */ 
		protected static var commentRe:RegExp = /^#/;
		/**
		 * @protected
		 */
		protected static const EOF:int = -1;
		
		public function NetPBMDecoder()
		{
		}
		
		public function decode():BitmapData
		{
			var data:BitmapData;
			
			
			return data;
		}
		
		
		protected function isComment(line:String):Boolean
		{
			return commentRe.test(line);
		}
	}
}