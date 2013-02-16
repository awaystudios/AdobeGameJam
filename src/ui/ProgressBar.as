package ui
{
	import com.greensock.TweenLite;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class ProgressBar extends Sprite
	{
		private var _value:Number;
		private var _stroke:Shape;
		private var _bar:Shape;
		
		public function ProgressBar(w:int=100, h:int=20)
		{
			_drawBar(w, h);
			_drawStroke(w, h);
			
			value = 0;
		}
		
		private function _drawStroke(w:int, h:int):void
		{
			_stroke = new Shape();
			_stroke.graphics.lineStyle(5, 0x666666);
			_stroke.graphics.beginFill(0xFFFFFF, .5);
			_stroke.graphics.drawRect(0,0,w,h);
			_stroke.graphics.endFill();
			
			addChild(_stroke);
		}
		
		private function _drawBar(w:int, h:int):void
		{
			_bar = new Shape();
			_bar.graphics.beginFill(0xFF0000);
			_bar.graphics.drawRect(0,0,w,h);
			_bar.graphics.endFill();
			
			addChild(_bar);
		}

		public function get value():Number { return _value; }
		public function set value(value:Number):void
		{
			_value = value;
			
			TweenLite.to(_bar, 0.2, {scaleX: Math.min(_value, 1)});
		}

	}
}