package org.hyzhak.starling.display
{
	import flash.geom.Point;
	
	import org.hyzhak.starling.display.knob.RotateKnobMode;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class KnobControl extends ControlWithBackground
	{
		
		//----------------------------------
		//  constants
		//----------------------------------
		
		public static const VERTICAL:String = "vertical";
		public static const HORIZONTAL:String = "horizontal";
		public static const ROTATE:String = "rotate";
		public static const UNLIMITED_ROTATE:String = "unlimitedRotate";
		
		//----------------------------------
		//  params 
		//----------------------------------
		
		private var _mode : IKnobMode = new RotateKnobMode();
		
		private var _value : Number = 0;
		
		private var _delta : Number = 1;
		
		private var _minimum : Number = 0;
		
		private var _maximum : Number = 1;
		
		private var _infinite : Boolean = false;
		
		private var _touchId:int = -1;
		private var _centerX:Number;
		private var _centerY:Number;
		
		public function KnobControl()
		{
			super();
			
			useHandCursor = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public.Methods
		//
		//--------------------------------------------------------------------------

		public function get value():Number
		{
			return _value;
		}

		public function set value(value:Number):void
		{
			if(_value == value)
			{
				return;
			}
			
			_value = value;
			
			_buttonSkin.rotation = 2 * Math.PI * value / delta;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get delta():Number
		{
			return _delta;
		}
		
		public function set delta(value:Number):void
		{
			_delta = value;
		}
		
		public function get minimum():Number
		{
			return _minimum;
		}
		
		public function set minimum(value:Number):void
		{
			_minimum = value;
		}
		
		public function get maximum():Number
		{
			return _maximum;
		}
		
		public function set maximum(value:Number):void
		{
			_maximum = value;
		}
		
		public function get infinite():Boolean
		{
			return _infinite;
		}
		
		public function set infinite(value:Boolean):void
		{
			_infinite = value;
		}
		
		public function get centerX() : Number
		{
			return x + 0.5 * width;
		}
		
		public function get centerY() : Number
		{
			return y + 0.5 * height;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Skins
		//
		//--------------------------------------------------------------------------
		
		private var _buttonSkin : DisplayObject;
		
		public function get buttonSkin():DisplayObject
		{
			return _buttonSkin;
		}
		
		public function set buttonSkin(value:DisplayObject):void
		{
			if(_buttonSkin == value)
			{
				return;
			}
			
			if(_buttonSkin)
			{
				this.removeChild(_buttonSkin);
			}
			
			_buttonSkin = value;
			
			if(_buttonSkin)
			{
				//_buttonSkin.touchable = false;
				_centerX = _buttonSkin.width / 2;
				_centerY = _buttonSkin.height / 2;
				_buttonSkin.x = _centerX;
				_buttonSkin.y = _centerY;
				_buttonSkin.pivotX = _centerX / _buttonSkin.scaleX;
				_buttonSkin.pivotY = _centerY / _buttonSkin.scaleY;
				this.addChild(_buttonSkin);
			}
			
			this.invalidate(INVALIDATION_FLAG_SKIN);
		}
		
		private var _buttonHotspotSkin : DisplayObject;
		
		public function get buttonHotspotSkin():DisplayObject
		{
			return _buttonHotspotSkin;
		}
		
		public function set buttonHotspotSkin(value:DisplayObject):void
		{
			if(_buttonHotspotSkin == value)
			{
				return;
			}
			
			if(_buttonHotspotSkin)
			{
				this.removeChild(_buttonHotspotSkin);
			}
			
			_buttonHotspotSkin = value;
			
			if(_buttonHotspotSkin)
			{
				//_buttonSkin.touchable = false;
				this.addChild(_buttonHotspotSkin);
			}
			
			this.invalidate(INVALIDATION_FLAG_SKIN);
		}

		//--------------------------------------------------------------------------
		//
		//  Overridable
		//
		//--------------------------------------------------------------------------
		
		override protected function initialize():void
		{
			super.initialize();
			addEventListener(TouchEvent.TOUCH, onTouch);
		}			
		
		private function onTouch(event : TouchEvent):void
		{
			for each(var touch : Touch in event.touches)
			{
				var localPoint : Point = touch.getLocation(this);				
				switch(touch.phase)
				{
					case TouchPhase.BEGAN:
						if(hitTest(localPoint))
						{
							_touchId = touch.id;
							localPoint.x -= _centerX;
							localPoint.y -= _centerY;
							_mode.start(this, localPoint.x, localPoint.y);
						}
						break;
					case TouchPhase.MOVED:
						if(touch.id == _touchId)
						{
							localPoint.x -= _centerX;
							localPoint.y -= _centerY;
							value = _mode.calcValue(this, localPoint.x, localPoint.y);
						}
						break;
					case TouchPhase.ENDED:
						if(touch.id == _touchId)
						{
							_touchId = -1;
						}
						break;
				}
			}
		}
	}
}