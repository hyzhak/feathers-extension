package org.hyzhak.starling.display
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;

	public class WhiteNoiseImage extends DynamicImage
	{
		public function WhiteNoiseImage(width:int=32, height:int=32)
		{
			super(width, height);
		}
		
		override protected function validateBitmapData(bitmapData : BitmapData) : void
		{
			bitmapData.noise(int.MAX_VALUE * Math.random(), 0, 255, BitmapDataChannel.RED | BitmapDataChannel.BLUE | BitmapDataChannel.GREEN, true);
		}
	}
}