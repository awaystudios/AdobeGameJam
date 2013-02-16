package
{
	import away3d.cameras.lenses.*;
	import away3d.containers.*;
	import away3d.controllers.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	import awayphysics.dynamics.*;
	
	import loaders.*;
	
	[SWF(backgroundColor="#333338", frameRate="60", quality="LOW")]
	public class Test3D extends Sprite
	{
		private var _view3D:View3D;
		private var _physicsWorld:AWPDynamicsWorld;
		private var _assetLoader:AssetsLoader;
		private var _assetFactory:AssetFactory;
		
		private var _cameraController:HoverController;
		private var _timeStep:Number = 1.0 / 60;
		
		//navigation
		private var _prevPanAngle:Number;
		private var _prevTiltAngle:Number;
		private var _prevMouseX:Number;
		private var _prevMouseY:Number;
		private var _mouseMove:Boolean;
		
		public function Test3D()
		{
			_view3D = new View3D();
			_view3D = new View3D();
			addChild(_view3D);
			
			//create custom lens
			_view3D.camera.lens = new PerspectiveLens(70);
			_view3D.camera.lens.far = 30000;
			_view3D.camera.lens.near = 1;
			
			_physicsWorld = new AWPDynamicsWorld();
			_physicsWorld.initWithDbvtBroadphase();
			_physicsWorld.gravity = new Vector3D(0, -10, 0);
			
			//setup controller to be used on the camera
			_cameraController = new HoverController(_view3D.camera, null, 90, 10, 500, 10, 90);
			_cameraController.minTiltAngle = -60;
			_cameraController.maxTiltAngle = 60;
			_cameraController.autoUpdate = false;
			_cameraController.wrapPanAngle = true;
			
			_assetLoader = new AssetsLoader();
			_assetLoader.addEventListener(Event.COMPLETE, onComplete);
			_assetLoader.startLoading();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			//add key listeners
			//stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			//navigation
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseUp);
			
			//add resize event
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		protected function onEnterFrame(event:Event):void
		{
			_physicsWorld.step(_timeStep);
			
			if (_mouseMove) {
				_cameraController.panAngle = 0.3*(stage.mouseX - _prevMouseX) + _prevPanAngle;
				_cameraController.tiltAngle = 0.3*(stage.mouseY - _prevMouseY) + _prevTiltAngle;
			}
			
			_cameraController.update();
			_view3D.render();
		}
		
		protected function onComplete(event:Event):void
		{
			_assetFactory = new AssetFactory(_view3D, _physicsWorld, _assetLoader);
			_assetFactory.addCar(0);
		}
		
		
		/**
		 * stage listener and mouse control
		 */
		private function onResize(event:Event=null):void
		{
			var w:uint = stage.stageWidth;
			var h:uint = stage.stageHeight;
			
			_view3D.width = w;
			_view3D.height = h;
		}
		
		/**
		 * Mouse down listener for navigation
		 */
		private function onMouseDown(ev:MouseEvent):void
		{
			_prevPanAngle = _cameraController.panAngle;
			_prevTiltAngle = _cameraController.tiltAngle;
			_prevMouseX = ev.stageX;
			_prevMouseY = ev.stageY;
			_mouseMove = true;
		}
		
		/**
		 * Mouse up listener for navigation
		 */
		private function onMouseUp(event:Event):void
		{
			_mouseMove = false;
		}
		
		/**
		 * mouseWheel listener
		 */
		private function onMouseWheel(ev:MouseEvent):void
		{
			_cameraController.distance -= ev.delta * 5;
			
			if (_cameraController.distance < 100)
				_cameraController.distance = 100;
			else if (_cameraController.distance > 2000)
				_cameraController.distance = 2000;
		}
	}
}