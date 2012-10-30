package org.hyzhak.starling.display.knob
{
	public interface IKnobMode
	{
		function start(knob:KnobControl, x : Number, y : Number) : void;
		
		function calcValue(knob : KnobControl, x : Number, y : Number) : Number;
	}
}