package views
{
	import com.bit101.components.ColorChooser;
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	import com.bit101.components.VBox;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.controllers.HoverController;
	import away3d.debug.AwayStats;
	import away3d.primitives.WireframeCube;
	import away3d.primitives.WireframePlane;
	import away3d.primitives.WireframePrimitiveBase;
	import away3d.primitives.WireframeSphere;
	
	import awayphysics.collision.shapes.AWPStaticPlaneShape;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.dynamics.AWPRigidBody;
	
	import data.CarInstance;
	
	import loaders.AssetFactory;
	import loaders.AssetsLoader;
	
	import ui.ArrowButton;
	
	public class GarageView extends Away3DView
	{
		public var btNext:ArrowButton;
		public var btPrev:ArrowButton;
		
		public var floor:WireframePlane;
		public var cube:WireframeCube;
		public var sphere:WireframeSphere;
		public var cameraController:HoverController;
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
//		public var currentModel : ObjectContainer3D;
		private var physicsWorld:AWPDynamicsWorld;
		private var _assetLoader:AssetsLoader;
		private var _assetFactory:AssetFactory;
		private var _timeStep:Number = 1.0 / 60;
		//navigation
		private var _prevPanAngle:Number;
		private var _prevTiltAngle:Number;
		private var _prevMouseX:Number;
		private var _prevMouseY:Number;
		private var _mouseMove:Boolean;
		private var currentCar:CarInstance;
		
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
//			modelList.push(cube);
//			modelList.push(sphere);
//			
//			currentModel = modelList[User.selectedCarIndex]; 
			
//			(currentModel as WireframePrimitiveBase).color = User.bodyColor;
			
//			view3D.scene.addChild(currentModel);
			
			view3D.camera.lens = new PerspectiveLens(70);
			view3D.camera.lens.far = 30000;
			view3D.camera.lens.near = 1;
			
			physicsWorld = new AWPDynamicsWorld();
			physicsWorld.initWithDbvtBroadphase();
			physicsWorld.gravity = new Vector3D(0, -10, 0);
			
			_createFloor();
			
//			cameraController = new HoverController(view3D.camera);
//			cameraController.distance = 1000;
//			cameraController.minTiltAngle = 0;
//			cameraController.maxTiltAngle = 90;
//			cameraController.panAngle = 45;
//			cameraController.tiltAngle = 20;
			
			cameraController = new HoverController(view3D.camera, null, 90, 10, 500, 10, 90);
			cameraController.minTiltAngle = -60;
			cameraController.maxTiltAngle = 60;
			cameraController.autoUpdate = false;
			cameraController.wrapPanAngle = true;
			
			
			_assetLoader = new AssetsLoader();
			_assetLoader.addEventListener(Event.COMPLETE, onComplete);
			_assetLoader.startLoading();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
//			stage.addEventListener(Event.MOUSE_LEAVE, onMouseUp);
		}
		
		private function _createFloor():void
		{
			floor = new WireframePlane(700,700, 10,10,0xFFFFFF,1, "xz");
			view3D.scene.addChild(floor);
			
			var groundShape : AWPStaticPlaneShape = new AWPStaticPlaneShape(new Vector3D(0, 1, 0));
			var groundRigidbody : AWPRigidBody = new AWPRigidBody(groundShape, floor, 0);
			physicsWorld.addRigidBody(groundRigidbody);
			
		}
		
		protected function onComplete(event:Event):void
		{
			_assetFactory = new AssetFactory(view3D, physicsWorld, _assetLoader);
			currentCar = _assetFactory.addCar(User.selectedCarIndex);
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
			
			_assetFactory.setBodyColor(currentCar, User.rimsColor);
			//_updateColors();
		}
		
		private function _changeBodyColor(event:Event):void
		{
			User.bodyColor = bodyColorChooser.value;	
			
			_assetFactory.setBodyColor(currentCar, User.bodyColor);
			//_updateColors();
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
			physicsWorld.step(_timeStep);
			
			if (move)
			{	
				cameraController.panAngle = 0.3*(stage.mouseX - lastMouseX) + lastPanAngle;
				cameraController.tiltAngle = 0.3*(stage.mouseY - lastMouseY) + lastTiltAngle;
			}
			else
			{
//				modelList[User.selectedCarIndex].rotationY += 1;
			}
			
			cameraController.update();
			
			super.render(event);
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			lastPanAngle = cameraController.panAngle;
			lastTiltAngle = cameraController.tiltAngle;
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
		
		private function onMouseWheel(ev:MouseEvent):void
		{
			cameraController.distance -= ev.delta * 5;
			
			if (cameraController.distance < 100)
				cameraController.distance = 100;
			else if (cameraController.distance > 2000)
				cameraController.distance = 2000;
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
//			view3D.scene.removeChild(currentModel);
			_assetFactory.removeCar(currentCar);
			
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
			
			currentCar = _assetFactory.addCar(0);
//			currentModel = _assetFactory.addCar(User.selectedCarIndex).carContainer;
			//view3D.scene.addChild(currentModel);
			
			_assetFactory.setBodyColor(currentCar, User.bodyColor);
			_assetFactory.setRimColor(currentCar, User.rimsColor);
			
			//_updateColors();
		}
		
		private function _updateColors () : void
		{
//			(currentModel as WireframePrimitiveBase).color = User.bodyColor;
		}
	}
}