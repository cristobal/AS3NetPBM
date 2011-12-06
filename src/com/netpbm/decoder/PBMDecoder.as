package com.netpbm.decoder
{
	import com.netpbm.NetPBM;
	
	import flash.display.BitmapData;

	public final class PBMDecoder extends NetPBMDecoder
	{
		public function PBMDecoder()
		{
			super();
		}
		
		/**
		 * Decode
		 * 
		 * @param reader
		 * @return The bitmapData
		 */ 
		override public function decode():BitmapData
		{
			var data:BitmapData;
/*			reader.reset();*/
			
/*			var type:String = reader.readLine();
			switch(type) {
				case NetPBM.PORTABLE_BITMAP_ASCII: {
					data = decodeASCII(reader);
					break;
				}
				case NetPBM.PORTABLE_BITMAP_BINARY: {
					data = decodeBinary(reader);
					break;
				}
			}*/
			
			return data;
		}
		
		/**
		 * Decode ascii
		 * 
		 * @param reader
		 */ 
		private function decodeASCII(reader:Object):BitmapData
		{
			var data:BitmapData;
/*			var width:uint, height:uint;
			var x:uint = 0, y:uint = 0;
			var args:Array;
			var color:uint;
			
			var line:String;
			while (line = reader.readLine()) {
				if (!data) {
					if (isComment(line)) {
						continue; // drop comments
					}
				}
				
				if (!data) {
					args = line.split(" ");
					width = uint(args[0]);
					height = uint(args[1]);
					

					data = new BitmapData(width, height, false, 0);
				}
				else {
					x = 0;
					args = line.split(" ");
					for (; x < width; x++) {
						color = uint(args[x]);
						if (color > 0) {
							data.setPixel(x, y, 0xFFFFFF);	
						}
						
					}
					y++;
				}
				
			}*/
			
			return data;
		}
		
		/**
		 * Decode binary
		 * 
		 * @param reader
		 */ 
		private function decodeBinary(reader:Object):BitmapData
		{
			var data:BitmapData;
			/*var width:uint, height:uint;
			var x:uint = 0, y:uint = 0;
			var color:uint;
			
			var line:String;
			while (line = reader.readLine()) {
				trace("line:" , line);
				if (!data) {
					if (isComment(line)) {
						continue;
					}
				}
				
				if (!data) {
					var args:Array = line.split(" ");
					width = uint(args[0]);
					height = uint(args[1]);
					
					data = new BitmapData(width, height, false, 0);
					// break; // jump out
				}
				
			}
			
			var char:int, index:uint = 0;
			// reader.read();
/*			while((char = reader.read()) != EOF){
				trace("read", index++, char);
			}*/
			// trace("last char:", char, "last line:", reader.readLine(), reader.stream().length);
			
			
			
			return data;
		}
	}
}