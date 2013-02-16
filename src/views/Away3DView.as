package views
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import away3d.containers.View3D;
	
	import potato.modules.navigation.View;

	public class Away3DView extends View
	{
		public var view3D:View3D;
		
		//public function Away3DView()
		//{
		//	stage ? setup() : addEventListener(Event.ADDED_TO_STAGE,setup);
		//}
		
		//public function setup(event:Event=null):void
		//{
		//	removeEventListener(Event.ADDED_TO_STAGE,setup);
		//	init();
		//}
		
		override public function init():void
		{
			view3D = new View3D();
			view3D.antiAlias = 4;
			view3D.camera.z = -600;
			view3D.camera.y = 500;
			view3D.camera.lookAt(new Vector3D());
			
			addChild(view3D);
			addEventListener(Event.ENTER_FRAME, render);
			
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		override public function dispose():void
		{
			removeEventListener(Event.ENTER_FRAME, render);
//			stage.removeEventListener(Event.RESIZE, onResize);
			removeChild(view3D);
			
			view3D.dispose();
		}
		
		protected function render(event:Event):void
		{
			view3D.render();
		}
		
		private function onResize(event:Event = null):void
		{
			view3D.width = stage.stageWidth;
			view3D.height = stage.stageHeight;
		}
	}
}