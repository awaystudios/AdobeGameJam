package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	
	public class Main extends Sprite
	{
		private var cmStarling:Starling;
		private var singleton:Singleton;
		
		public function Main()
		{
			trace('main initialized');
			
			singleton = Singleton.getInstance();
			
			/** Set Stage Properties */
			
			stage.frameRate=60;
			//stage.color=0x111111;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.displayState = StageDisplayState.FULL_SCREEN;

			/* Calculated Resolution */
			
			singleton._stageWidth=stage.stageWidth;//stage.fullScreenWidth;
			singleton._stageHeight=stage.stageHeight;//stage.fullScreenHeight;
			
			//Starling.multitouchEnabled = true;
			
			Starling.handleLostContext = true;
			
			addEventListener(Event.CONTEXT3D_CREATE, lostStarling);

			cmStarling = new Starling(Hud, stage);//, new Rectangle(0, 0, singleton._stageWidth, singleton._stageHeight));
			
			cmStarling.antiAliasing = 0;
			
			//Starling.current.showStats = true;
			
			cmStarling.start(); 
			
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		protected function onResize(event:Event):void
		{
			// TODO Auto-generated method stub
			singleton._stageWidth=stage.stageWidth;//stage.fullScreenWidth;
			singleton._stageHeight=stage.stageHeight;//stage.fullScreenHeight;

			if( singleton.refreshStarling != null )
				singleton.refreshStarling();
		}
		
		/**
		 *	Lost Starling
		 */
		
		private function lostStarling(e:Event):void
		{
			e=e;
			cmStarling.dispose();
		}

	}
}