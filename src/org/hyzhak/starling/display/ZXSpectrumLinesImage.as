package org.hyzhak.starling.display
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class ZXSpectrumLinesImage extends DynamicImage
	{
		private var _colors : Array = [0xff000000, 0xffffffff];
		
		private var _lineHeightAvg : int = 4;
		
		private var _lineHeightDev : int = 1;
		
		public function ZXSpectrumLinesImage(width:int=32, height:int=32)
		{
			super(width, height);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public.Methods
		//
		//--------------------------------------------------------------------------
		
		public function get lineHeightAvg():int
		{
			return _lineHeightAvg;
		}

		public function set lineHeightAvg(value:int):void
		{
			_lineHeightAvg = value;
		}

		public function get lineHeightDev():int
		{
			return _lineHeightDev;
		}

		public function set lineHeightDev(value:int):void
		{
			_lineHeightDev = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private.Methods
		//
		//--------------------------------------------------------------------------
		
		override protected function validateBitmapData(bitmapData:BitmapData):void
		{
			drawLines(bitmapData, _colors, lineHeightAvg, lineHeightDev);
		}
		
		private static var drawLinesRect : Rectangle = new Rectangle();
		
		private function drawLines(bitmapData:BitmapData, colors : Array, lineHeightAvg:int, lineHeightDev:int):void
		{
			bitmapData.lock();
			var colorIndex:int = 0;
			//			var colorIndex:int = colors.length * Math.random();
			var lineIndex : int = 0;
			var rect : Rectangle = drawLinesRect;
			rect.width = bitmapData.width;
			for(var y : int = 0, height : int = bitmapData.height; y < height; )
			{
				var color : uint = colors[colorIndex++];
				if(colorIndex >= colors.length)
				{
					colorIndex = 0;
				}
				
				++lineIndex;
				
				var nextLineY : int = lineIndex * lineHeightAvg + 2 * lineHeightDev * (Math.random() - 0.5);
				
				rect.y = y;
				rect.height = nextLineY - y;
				
				bitmapData.fillRect(rect, color);
				y = nextLineY;
			}
			bitmapData.unlock();
		}
	}
}