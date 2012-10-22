package org.hyzhak.starling.display
{
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	
	import feathers.display.TiledImage;
	
	import starling.core.RenderSupport;
	import starling.textures.Texture;
	
	public class DynamicImage extends TiledImage
	{
		private var _textureWidth : int = 32;
		private var _textureHeight : int = 32;
		private var _bitmapData:BitmapData;
		private var _invalideTexture:Boolean;
		private var _invalideTextureSize:Boolean;
		
		public function DynamicImage(width : int = 32, height:int = 32)
		{
			_textureWidth = width;
			_textureHeight = height;
			super(buildTexture());			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public.Methods
		//
		//--------------------------------------------------------------------------
		
		public function get textureHeight():int
		{
			return _textureHeight;
		}

		public function set textureHeight(value:int):void
		{
			if(_textureHeight == value)
			{
				return;
			}
			
			_textureHeight = value;
			invalidateTextureSize();
		}

		public function get textureWidth():int
		{
			return _textureWidth;
		}

		public function set textureWidth(value:int):void
		{
			if(_textureWidth == value)
			{
				return;
			}
			
			_textureWidth = value;
			invalidateTextureSize();
		}

		public function invalidateTexture() : void
		{
			_invalideTexture = true;
		}

		private function invalidateTextureSize() : void
		{
			_invalideTextureSize = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridable
		//
		//--------------------------------------------------------------------------
		
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			if(alpha > 0)
			{
				if(_invalideTextureSize)
				{
					_invalideTextureSize = false;
					validateTextureSize();
				}
				else if(_invalideTexture)
				{
					_invalideTexture = false;
					validateTexture();
				}				
			}
			
			super.render(support, parentAlpha);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Private.Methods
		//
		//--------------------------------------------------------------------------
		
		private function validateTextureSize() : void
		{
			if(texture)
			{
				texture.dispose();
			}
			
			texture = buildTexture();
		}
		
		private function buildTexture():starling.textures.Texture
		{
			if(_bitmapData)
			{
				_bitmapData.dispose();
			}
			
			_bitmapData = new BitmapData(textureWidth, textureHeight);
			validateBitmapData(_bitmapData);
			return starling.textures.Texture.fromBitmapData(_bitmapData);
		}
		
		private function validateTexture() : void
		{
			validateBitmapData(_bitmapData);			
			
			(texture.base as flash.display3D.textures.Texture).uploadFromBitmapData(_bitmapData);
		}
		
		protected function validateBitmapData(bitmapData : BitmapData) : void
		{
			
		}
	}
}