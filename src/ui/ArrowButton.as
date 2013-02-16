package ui
{
	import com.greensock.TweenLite;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
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
			
			_rollout();
			
			addChild(_arrow);
			
			addEventListener(MouseEvent.ROLL_OVER, _rollover);
			addEventListener(MouseEvent.ROLL_OUT, _rollout);
			addEventListener(MouseEvent.CLICK, _click);
		}
		
		private function _click ( event : MouseEvent ) : void
		{
			//TweenLite.to(
		}
		
		private function _rollover ( event : MouseEvent = null ) : void
		{	
			TweenLite.to(this, .1, { scaleX: 1, scaleY: 1, alpha: 1});
		}
		
		private function _rollout ( event : MouseEvent = null ) : void
		{
			TweenLite.to(this, .1, { scaleX: .8, scaleY: .8, alpha: .8});
		}
	}
}