package views
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import away3d.controllers.HoverController;
	import away3d.debug.AwayStats;
	import away3d.primitives.WireframePlane;
	
	import ui.ArrowButton;
	
	public class GarageView extends Away3DView
	{
		public var btNext:ArrowButton;
		public var btPrev:ArrowButton;
		
		public var plane:WireframePlane;
		public var camController:HoverController;
		public var stats:AwayStats;
		
		//navigation variables
		private var move:Boolean = false;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		
		//car models
		
		override public function init():void
		{
			super.init();
			
			plane = new WireframePlane(700,700);
			view3D.scene.addChild(plane);
			
			camController = new HoverController(view3D.camera);
			camController.distance = 1000;
			camController.minTiltAngle = 0;
			camController.maxTiltAngle = 90;
			camController.panAngle = 45;
			camController.tiltAngle = 20;
			
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			btPrev = new ArrowButton();
			btPrev.addEventListener(MouseEvent.CLICK, _prev);
			
			btNext = new ArrowButton();
			btNext.addEventListener(MouseEvent.CLICK, _next);
			
			addChild(btPrev);
			addChild(btNext);
			addChild(stats = new AwayStats(view3D))
		}
		
		override public function dispose () : void 
		{
			removeChild(stats);
			
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			super.dispose();
		}
		
		override protected function render ( event : Event ) : void
		{
			if (move)
			{	
				camController.panAngle = 0.3*(stage.mouseX - lastMouseX) + lastPanAngle;
				camController.tiltAngle = 0.3*(stage.mouseY - lastMouseY) + lastTiltAngle;
			}
			else
			{
				plane.rotationY += 1;
			}
			
			super.render(event);
		}
		
		/**
		 * Mouse down listener for navigation
		 */
		private function onMouseDown(event:MouseEvent):void
		{
			lastPanAngle = camController.panAngle;
			lastTiltAngle = camController.tiltAngle;
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
			move = true;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		/**
		 * Mouse up listener for navigation
		 */
		private function onMouseUp(event:MouseEvent):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		/**
		 * Mouse stage leave listener for navigation
		 */
		private function onStageMouseLeave(event:Event):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function _prev ( event : Event = null ) : void
		{
			//change car
		}
		
		private function _next ( event : Event = null ) : void
		{
			//change car	
		}
	}
}