package ui
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class ArrowButton extends Sprite
	{
		private const SIZE:int = 50;
		
		private var _arrow:Shape;
		
		public function ArrowButton()
		{
			_arrow = new Shape();
			_arrow.graphics.beginFill(0xFFFFFF);
			_arrow.graphics.moveTo(0,0);
			_arrow.graphics.lineTo(SIZE, SIZE*2);
			_arrow.graphics.lineTo(SIZE*2, 0);
			_arrow.graphics.lineTo(0,0);
			_arrow.graphics.endFill();
			_arrow.x = _arrow.y = -SIZE;
			
			addChild(_arrow);
		}
	}
}