package org.hyzhak.starling.display.knob
{
	import flash.geom.Point;
	
	import org.hyzhak.starling.display.ControlWithBackground;
	
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
		
		private var _radius:Number;
		
		private var _zeroPointAngle : Number;
		
		private var _maximumPointAngle : Number;
		
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

		public function get maximumPointAngle():Number
		{
			return _maximumPointAngle;
		}

		public function set maximumPointAngle(value:Number):void
		{
			if(_maximumPointAngle == value)
			{
				return;
			}
			
			_maximumPointAngle = value;
			refreshDelta();
			invalidate(INVALIDATION_FLAG_DATA);
		}

		public function get zeroPointAngle():Number
		{
			return _zeroPointAngle;
		}

		public function set zeroPointAngle(value:Number):void
		{
			if(_zeroPointAngle == value)
			{
				return;
			}
			_zeroPointAngle = value;
			refreshDelta();
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		private function refreshDelta():void
		{
			if(!(isNaN(zeroPointAngle) || isNaN(maximumPointAngle)))
			{
				delta = 2 * Math.PI / (maximumPointAngle - zeroPointAngle);
			}
		}
		
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
			
			dispatchEventWith(Event.CHANGE);
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			super.draw();
			
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			
			if(dataInvalid)
			{
				var rotation : Number;
				
				rotation = 2 * Math.PI * value / delta;
				
				if(!isNaN(zeroPointAngle))
				{
					rotation += zeroPointAngle;
				}
				
				_buttonSkin.rotation = rotation;				
			}
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
		
		public function get radius() : Number
		{
			return _radius;
		}
		
		public function set radius(value : Number) : void
		{
			if(_radius == value)
			{
				return;
			}
			
			_radius = value;
			width = _radius;
			height = _radius;			
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			knobSkin.width = value;
			buttonHotspotSkin.width = value;
		}
		
		override public function set height(value : Number) : void
		{
			super.height = value;
			knobSkin.height = value;
			buttonHotspotSkin.height = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Skins
		//
		//--------------------------------------------------------------------------
		
		private var _buttonSkin : DisplayObject;
		
		public function get knobSkin():DisplayObject
		{
			return _buttonSkin;
		}
		
		public function set knobSkin(value:DisplayObject):void
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
				_centerX = _buttonHotspotSkin.width / 2;
				_centerY = _buttonHotspotSkin.height / 2;
				_buttonHotspotSkin.x = _centerX;
				_buttonHotspotSkin.y = _centerY;
				_buttonHotspotSkin.pivotX = _centerX / _buttonHotspotSkin.scaleX;
				_buttonHotspotSkin.pivotY = _centerY / _buttonHotspotSkin.scaleY;
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