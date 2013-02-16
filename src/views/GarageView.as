package views
{
	import com.bit101.components.ColorChooser;
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	import com.bit101.components.VBox;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.controllers.HoverController;
	import away3d.debug.AwayStats;
	import away3d.primitives.WireframeCube;
	import away3d.primitives.WireframePrimitiveBase;
	import away3d.primitives.WireframeSphere;
	
	import ui.ArrowButton;
	
	public class GarageView extends Away3DView
	{
		public var btNext:ArrowButton;
		public var btPrev:ArrowButton;
		
		public var cube:WireframeCube;
		public var sphere:WireframeSphere;
		public var camController:HoverController;
		public var stats:AwayStats;
		
		//navigation variables
		private var move:Boolean = false;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		
		private var bodyColorChooser:ColorChooser;
		private var rimsColorChooser:ColorChooser;
		
		//car models
		public var modelList : Array = [];
		public var currentModel : ObjectContainer3D;
		
		override public function init():void
		{
			super.init();
			
			_setup3D();
			_setupUI();
		}
		
		private function _setup3D () : void
		{	
			cube = new WireframeCube(700,700);
			sphere = new WireframeSphere(350);
			modelList.push(cube);
			modelList.push(sphere);
			
			currentModel = modelList[User.selectedCarIndex]; 
			
			(currentModel as WireframePrimitiveBase).color = User.bodyColor;
			view3D.scene.addChild(currentModel);
			
			camController = new HoverController(view3D.camera);
			camController.distance = 1000;
			camController.minTiltAngle = 0;
			camController.maxTiltAngle = 90;
			camController.panAngle = 45;
			camController.tiltAngle = 20;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function _setupUI () : void
		{
			btPrev = new ArrowButton();
			btPrev.addEventListener(MouseEvent.CLICK, _prev);
			btPrev.rotation = 90;
			btPrev.x = btPrev.width;
			btPrev.y = int(stage.stageHeight*.5);
			
			btNext = new ArrowButton();
			btNext.addEventListener(MouseEvent.CLICK, _next);
			btNext.rotation = -90;
			btNext.x = stage.stageWidth - btNext.width;
			btNext.y = btPrev.y;
			
			var vBox : VBox = new VBox(this, 100, 100);
			var hBox : HBox = new HBox(vBox);
			var label : Label = new Label(hBox, 0, 0, "Body color:");
			bodyColorChooser = new ColorChooser(hBox, 0, 0, User.bodyColor, _changeBodyColor);
			bodyColorChooser.usePopup = true;
			
			
			hBox = new HBox(vBox);
			label = new Label(hBox, 0, 0, "Rims color:");
			rimsColorChooser = new ColorChooser(hBox, 0, 0, User.rimsColor, _changeRimsColor);
			rimsColorChooser.usePopup = true;
			
			addChild(btPrev);
			addChild(btNext);
			addChild(stats = new AwayStats(view3D))
		}
		
		private function _changeRimsColor(event:Event):void
		{
			User.rimsColor = rimsColorChooser.value;
			
			_updateColors();
		}
		
		private function _changeBodyColor(event:Event):void
		{
			User.bodyColor = bodyColorChooser.value;	
			
			_updateColors();
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
				modelList[User.selectedCarIndex].rotationY += 1;
			}
			
			super.render(event);
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			lastPanAngle = camController.panAngle;
			lastTiltAngle = camController.tiltAngle;
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
			move = true;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function onStageMouseLeave(event:Event):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function _prev ( event : Event = null ) : void
		{
			_changeModel(-1);
		}
		
		private function _next ( event : Event = null ) : void
		{
			_changeModel(1);
		}
		
		private function _changeModel (direction:int = 1) : void
		{
			view3D.scene.removeChild(currentModel);
			
			if ( direction < 0 )
			{
				if ( --User.selectedCarIndex <= 0 )
				{
					User.selectedCarIndex = modelList.length - 1;
				}
			}
			else
			{
				if ( ++User.selectedCarIndex >= modelList.length )
				{
					User.selectedCarIndex = 0;
				}
			}
			currentModel = modelList[User.selectedCarIndex];
			view3D.scene.addChild(currentModel);
			
			_updateColors();
		}
		
		private function _updateColors () : void
		{
			(currentModel as WireframePrimitiveBase).color = User.bodyColor;
		}
	}
}