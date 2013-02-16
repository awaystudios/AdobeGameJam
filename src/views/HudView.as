package views
{
	import flash.events.Event;
	
	import potato.modules.navigation.View;
	
	import starling.core.Starling;
	
	public class HudView extends View
	{
		public var starlingHUD:Starling;
		
		override public function init():void
		{
			_initStarling();
			
			addEventListener(Event.ENTER_FRAME, render);
		}
		
		private function render(event:Event):void
		{
			// TODO Auto Generated method stub
//			starlingHUD.nextFrame()
		}
		
		private function _initStarling():void
		{
			Starling.handleLostContext = true;
			
			starlingHUD = new Starling(Hud, stage, User.sharedStage3DProxy.viewPort, User.sharedStage3DProxy.stage3D);
			starlingHUD.start();
			
			User.starling = starlingHUD;
		}
	}
}