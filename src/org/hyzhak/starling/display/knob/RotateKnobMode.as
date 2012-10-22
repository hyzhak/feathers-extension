package org.hyzhak.starling.display.knob
{
	import org.hyzhak.starling.display.IKnobMode;
	import org.hyzhak.starling.display.KnobControl;
	
	public class RotateKnobMode implements IKnobMode
	{
		private var _previousAngle:Number = 0;
		
		//--------------------------------------------------------------------------
		//
		//  Public.Methods
		//
		//--------------------------------------------------------------------------
		
		public function start(knob:KnobControl, x:Number, y:Number):void
		{
			_previousAngle = Math.atan2(y, x)
		}
		
		public function calcValue(knob:KnobControl, x:Number, y:Number):Number
		{
			var unlimitedAngle:Number = Math.atan2(y, x);
				
			var deltaAngle : Number = unlimitedAngle - _previousAngle;
			
			_previousAngle = unlimitedAngle;
			
			if(deltaAngle > Math.PI)
			{
				deltaAngle -= 2 * Math.PI;
			}
			else if(deltaAngle < -Math.PI)
			{
				deltaAngle += 2 * Math.PI;
			}
			
			var newValue : Number = knob.value + knob.delta * deltaAngle / (2 * Math.PI);
			
			if(!knob.infinite)
			{
				if(newValue > knob.maximum)
				{
					newValue = knob.maximum;
				}
				else if(newValue < knob.minimum)
				{
					newValue = knob.minimum;
				}
			}
			
			return newValue;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private.Methods
		//
		//--------------------------------------------------------------------------
		
		private function getAngle(knob:KnobControl, x : Number, y : Number) : Number
		{
			return Math.atan2(knob.centerY - y, knob.centerX - x);
		}
	}
}