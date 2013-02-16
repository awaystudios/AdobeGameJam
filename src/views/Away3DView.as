package views
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	
	import potato.modules.navigation.View;

	public class Away3DView extends View
	{
		public var view3D:View3D;
		
		public var stage3DManager:Stage3DManager;
		public var stage3DProxy:Stage3DProxy;
		
		override public function init():void
		{
			// Define a new Stage3DManager for the Stage3D objects
			stage3DManager = Stage3DManager.getInstance(stage);
			
			// Create a new Stage3D proxy to contain the separate views
			stage3DProxy = stage3DManager.getFreeStage3DProxy();
			//			stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
			stage3DProxy.antiAlias = 8;
			stage3DProxy.color = 0x0;
			
			view3D = new View3D();
			view3D.antiAlias = 4;
			view3D.camera.z = -600;
			view3D.camera.y = 500;
			view3D.camera.lookAt(new Vector3D());
			view3D.stage3DProxy = stage3DProxy;
			view3D.shareContext = true;
			
			addChild(view3D);
			
			
			
			
			stage3DProxy.addEventListener(Event.ENTER_FRAME, render);
			
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		override public function dispose():void
		{
			stage3DProxy.removeEventListener(Event.ENTER_FRAME, render);
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
			
			stage3DProxy.width = stage.stageWidth;
			stage3DProxy.height = stage.stageHeight;
		}
	}
}