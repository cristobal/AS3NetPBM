package com.netpbm.decoder
{
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	// TODO: PGM add support for max values > 255…
	// TODO: PGM use the ITU-R Recommendation BT.709 for the gamma transfer function LUT
	// TODO: Decode PPM
	// TODO: Add support for when lines are longer than 70chars…	
	
	/**
	 * NetPBMDecoder.as
	 * 
	 * @author Cristobal Dabed
	 * @version {{VERSION_NUMBER}}
	 */ 
	public class NetPBMDecoder
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		public static const PORTABLE_BITMAP:String  = "PBM";
		public static const PORTABLE_GRAYMAP:String	= "PGM";
		public static const PORTABLE_PIXMAP:String	= "PPM";
		
		public static const PORTABLE_BITMAP_ASCII:String  	= "P1";
		public static const PORTABLE_GRAYMAP_ASCII:String	= "P2";
		public static const PORTABLE_PIXMAP_ASCII:String	= "P3";
		public static const PORTABLE_BITMAP_BINARY:String 	= "P4";
		public static const PORTABLE_GRAYMAP_BINARY:String 	= "P5";
		public static const PORTABLE_PIXMAP_BINARY:String 	= "P6";
		
		/**
		 * @public
		 */ 
		public static const INVALID_FORMAT:String = "invalidFormat";
		
		/**
		 * @private
		 */ 
		private static const LF:int = "\n".charCodeAt(0);
		
		/**
		 * @private
		 */ 
		private static const CR:int = "\r".charCodeAt(0);
		
		
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------	
		
		/**
		 * @private
		 */ 
		private static var formatRe:RegExp = /^P(1|2|3|4|5|6)$/;

		/**
		 * @private
		 */ 
		private static var graymapRe:RegExp = /^P(2|5)$/;
		
		/**
		 * @private
		 */ 
		private static var pixmapRe:RegExp = /^P(3|6)$/;
		
		/**
		 * @private
		 */ 
		private static var binaryRe:RegExp = /^P(4|5|6)$/;

		/**
		 * @private
		 */ 
		private static var commentRe:RegExp = /^#/;

		/**
		 * @private
		 */ 
		private static var maskTable:Vector.<int> = Vector.<int>([
			0x01, /* 1 << 0 */
			0x02, /* 1 << 1 */
			0x04, /* 1 << 2 */
			0x08, /* 1 << 3 */
			0x10, /* 1 << 4 */
			0x20, /* 1 << 5 */
			0x40, /* 1 << 6 */
			0x80  /* 1 << 7 */
		]);
		
		/**
		 * @private
		 */ 
		private static var whiteColor:uint = 0xFFFFFF;
		
		/**
		 * @private
		 */ 
		private static var blackColor:uint = 0;
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Decode 
		 * 
		 * @param bytes
		 */ 
		public static function decode(bytes:ByteArray):BitmapData
		{
			var data:Object = readData(bytes);
			if (!validFormat(data.format)) {
				throw new Error(INVALID_FORMAT);
			}
			
			var width:int = data.width;
			var height:int = data.height;
			
			var bitmapData:BitmapData = new BitmapData(data.width, data.height, false, 0);
			switch (data.type) {
				case PORTABLE_BITMAP: {
					decodeBitmap(bytes, bitmapData, data.binary);
					break;
				}
				case PORTABLE_GRAYMAP: {
					decodeGraymap(bytes, bitmapData, data.max, data.binary);
					break;
				}
				case PORTABLE_PIXMAP: {
					// decodePixmap();
					break;
				}
			}
			
			return bitmapData;
		}
		
		//--------------------------------------
		//
		// Decode Bitmap (BMP)
		//
		//--------------------------------------
		
		/**
		 * Decode bitmap
		 * 
		 * @param bytes
		 * @param bitmapData
		 */ 
		private static function decodeBitmap(bytes:ByteArray, bitmapData:BitmapData, binary:Boolean):void
		{	
			
			var values:Vector.<uint> = bitmapData.getVector(bitmapData.rect);
			if (binary) {
				decodeBitmapBinary(values, bytes, bitmapData.width, bitmapData.height);
			}
			else {
				decodeBitmapASCII(values, bytes, bitmapData.width, bitmapData.height);
			}
			bitmapData.setVector(bitmapData.rect, values);
		}
		
		/**
		 * Decode bitmap binary
		 * 
		 * @param values
		 * @param bytes
		 * @param width
		 * @param height
		 */ 
		private static function decodeBitmapBinary(values:Vector.<uint>, bytes:ByteArray, width:int, height:int):void
		{	
			var byte:int;
			var bit:int
			
			var index:int = 0;
			var color:uint;
			var x:int = 0;
			// var y:int = 0;
			
			while(bytes.position < bytes.length) {
				byte = bytes.readByte() & 0xFF;
				for (var i:int = 8; i--;) {
					
					bit   = byte & maskTable[i];
					color = bit == maskTable[i] ? blackColor : whiteColor;
					
					values[index++]= color;
					
					x++;
					if (x == width) {
						x = 0;
						// y++;
						break;
					}
				}
			}	
		}
		
		/**
		 * Decode bitmap ascii
		 * 
		 * @param values
		 * @param bytes
		 * @param width
		 * @param height
		 */
		private static function decodeBitmapASCII(values:Vector.<uint>, bytes:ByteArray, width:int, height:int):void
		{
			
			var row:String;
			var args:Array;
			var value:int;
			var color:uint;
			for (var y:int = 0; y < height; y++) {
				row = readLine(bytes);
				
				// clean old format where we have spaces
				row = row.split(" ").join("");
				
				for (var x:int = 0; x < width; x++) {
					value = int(row.charAt(x));
					color = value == 1 ? blackColor : whiteColor;
					values[x + (y * width)] = color;
				}
			}
		}
		
		
		//--------------------------------------
		//
		// Decode Graymap (PGM)
		//
		//--------------------------------------
		
		/**
		 * Decode graymap 
		 * 
		 * @param bytes
		 * @param bitmapData
		 * @param max
		 * @param binary
		 */
		private static function decodeGraymap(bytes:ByteArray, bitmapData:BitmapData, max:int, binary:Boolean):void
		{
			
			var values:Vector.<uint> = bitmapData.getVector(bitmapData.rect);
			if (binary) {
				decodeGraymapBinary(values, bytes, max,bitmapData.width, bitmapData.height);
			}
			else {
				decodeGraymapASCII(values, bytes, max, bitmapData.width, bitmapData.height);
			}
			bitmapData.setVector(bitmapData.rect, values);
		}
		
		/**
		 * Decode graymap binary
		 * 
		 * @param values
		 * @param bytes
		 * @param width
		 * @param height
		 */ 
		private static function decodeGraymapBinary(values:Vector.<uint>, bytes:ByteArray, max:int, width:int, height:int):void
		{
			var value:int;
			var index:int = 0;
			var color:uint;
			var lut:Vector.<uint> = createGammaTransferLUT(max)
				
			while(bytes.position < bytes.length) {
				value = bytes.readByte() & 0xFF; // normalize byte in case - values…
				
				color = lut[value];
				values[index] = color;
				
				index++;
			}
			
		}
		
		/**
		 * Decode graymap ascii
		 * 
		 * @param values
		 * @param bytes
		 * @param width
		 * @param height
		 */
		private static function decodeGraymapASCII(values:Vector.<uint>, bytes:ByteArray, max:int, width:int, height:int):void
		{
			// trace("decodeGraymapASCII");
			var row:String;
			var arg:String;
			var args:Array;

			var value:int;
			var color:uint;
			var lut:Vector.<uint> = createGammaTransferLUT(max);
			
			for (var y:int = 0; y < height; y++) {
				row  = readLine(bytes);
				args = row.split(" ");
				
				for (var i:int = args.length; i--;) {
					arg = trim(args[i]);
					if (arg == "") {
						args.splice(i, 1);
					}
					else {
						args[i] = arg;
					}
				}
				
				for (var x:int = 0; x < width; x++) {
					value = int(args[x]);
					
					color = lut[value];
					values[x + (y * width)] = color;
				}
			}
		}
		
		/**
		 * Create gamma transfer lut
		 * 
		 * @param max value
		 */ 
		private static function createGammaTransferLUT(max:int):Vector.<uint> 
		{
			var lut:Vector.<uint> = new Vector.<uint>(max + 1);
			lut[0] = blackColor;
			var ratio:Number = 255 / max;
			var value:int;
			var color:uint;
			for (var i:int = 1; i < max; i++) {
				value = int(Math.floor(ratio * i));
				color = gray2pixel(value);
				lut[i] = color;
			}
			lut[max] = whiteColor;
				
			return lut;
		}
		
		/**
		 * Gray to pixel value
		 * 
		 * @param value
		 */
		private static function gray2pixel(value:int):uint
		{
			return (value << 16) | (value << 8) | value;
		}
		
		//--------------------------------------
		//
		// Common methods
		//
		//--------------------------------------
		
		/**
		 * Read data
		 * 
		 * @param bytes
		 */ 
		private static function readData(bytes:ByteArray):Object
		{
			var data:Object = {};
			data.format = readLine(bytes);
			if (validFormat(data.format)) {
				
				// read until no more comments
				var line:String;
				var count:uint = 0;
				while (true) {
					line = readLine(bytes);
					if (line) {
						
						if (!commentRe.test(line) && (trim(line) != "")) {
							break;
						}
					}	
					count++;
				}
				
				// Get WIDTHxHEIGHT.
				var args:Array = line.split(" ");
				
				data.width = int(args[0]);
				data.height = int(args[1]);
				
				data.type = PORTABLE_BITMAP;
				if (graymapRe.test(data.format)) {
					data.type = PORTABLE_GRAYMAP;
				}
				else if (pixmapRe.test(data.format)) {
					data.type = PORTABLE_GRAYMAP;
				}
				
				
				data.max = -1;
				// if graymap or pixmap get max value…
				if (data.type == PORTABLE_GRAYMAP || data.type == PORTABLE_PIXMAP) {
					data.max = int(readLine(bytes));
				}
				
				data.binary = binaryRe.test(data.format);
			}
			
			return data;
		}
		
		/**
		 * Valid
		 * 
		 * @param format
		 */ 
		private static function validFormat(format:String):Boolean
		{
			return formatRe.test(format);
		}
		
		
		/**
		 * Read line
		 * 
		 * @param bytes
		 */ 
		private static function readLine(bytes:ByteArray):String
		{
			var line:String = null;
			var char:int;
			var characters:Array = [];
			
			while(true) {
				char = bytes[bytes.position++];
				if ((char == LF) || (char == CR)) {
					break;
				}
				characters.push(char);
			}
			if (characters.length > 0) {
				line = String.fromCharCode.apply(String.fromCharCode, characters);
			}
			
			return line;
		}
		
		/**
		 * trim
		 * 
		 * @param value
		 */ 
		private static var trimLeft:RegExp = /^\s+/;
		private static var trimRight:RegExp = /\s+$/;
		private static function trim(value:String):String
		{
			return value ? value.replace(trimRight, '').replace(trimRight, '') : "";
		}
		
	}
}