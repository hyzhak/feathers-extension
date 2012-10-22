package org.hyzhak.starling.display
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;

	public class PerlinNoiseImage extends DynamicImage
	{
		public function PerlinNoiseImage(width:int=32, height:int=32)
		{
			super(width, height);
		}
		
		override protected function validateBitmapData(bitmapData : BitmapData) : void
		{
			bitmapData.perlinNoise(97, 73, 7, int.MAX_VALUE * Math.random(), true, false, BitmapDataChannel.RED | BitmapDataChannel.BLUE | BitmapDataChannel.GREEN, true, [10 * Math.random(), 10 * Math.random()]);
		}
	}
}