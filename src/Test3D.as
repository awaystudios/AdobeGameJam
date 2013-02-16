package
{
	import away3d.cameras.lenses.*;
	import away3d.containers.*;
	import away3d.controllers.*;
	import away3d.lights.*;
	import away3d.lights.shadowmaps.*;
	import away3d.materials.lightpickers.*;
	import away3d.materials.methods.*;
	import away3d.primitives.*;
	import away3d.textures.*;
	import away3d.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	import awayphysics.dynamics.*;
	
	import data.*;
	
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
		
		//light variables
		private var _sunLight:DirectionalLight;
		private var _skyLight:PointLight;
		private var _lightPicker:StaticLightPicker;
		
		//materials
		private var _skyMap:BitmapCubeTexture;
		private var _fog:FogMethod;
		private var _specularMethod:FresnelSpecularMethod;
		private var _shadowMethod:NearShadowMapMethod;

		//global light setting
		private var sunColor:uint = 0xAAAAA9;
		private var sunAmbient:Number = 0.4;
		private var sunDiffuse:Number = 0.5;
		private var sunSpecular:Number = 1;
		private var skyColor:uint = 0x333338;
		private var skyAmbient:Number = 0.2;
		private var skyDiffuse:Number = 0.3;
		private var skySpecular:Number = 0.5;
		private var fogColor:uint = 0x333338;
		
		public function Test3D()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			initGlobal();
			initLights();
		}
		
		public function initGlobal():void
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
		
		
		/**
		 * Initialise the lights
		 */
		private function initLights():void
		{
			//create a light for shadows that mimics the sun's position in the skybox
			_sunLight = new DirectionalLight();
			_sunLight.y = 1200;
			_sunLight.color = sunColor;
			_sunLight.ambientColor = sunColor;
			_sunLight.ambient = sunAmbient;
			_sunLight.diffuse = sunDiffuse;
			_sunLight.specular = sunSpecular;
			
			_sunLight.castsShadows = true;
			_sunLight.shadowMapper = new NearDirectionalShadowMapper(.1);
			_view3D.scene.addChild(_sunLight);
			
			//create a light for ambient effect that mimics the sky
			_skyLight = new PointLight();
			_skyLight.color = skyColor;
			_skyLight.ambientColor = skyColor;
			_skyLight.ambient = skyAmbient;
			_skyLight.diffuse = skyDiffuse;
			_skyLight.specular = skySpecular;
			_skyLight.y = 1200;
			_skyLight.radius = 1000;
			_skyLight.fallOff = 2500;
			_view3D.scene.addChild(_skyLight);
			
			
			//global methods
			_fog = new FogMethod(1000, 10000, 0x333338);
			_specularMethod = new FresnelSpecularMethod();
			_specularMethod.normalReflectance = 1.8;
			
			_shadowMethod = new NearShadowMapMethod(new FilteredShadowMapMethod(_sunLight));
			_shadowMethod.epsilon = .0007;
			
			//create light picker for materials
			_lightPicker = new StaticLightPicker([_sunLight, _skyLight]);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			_physicsWorld.step(_timeStep);
			
			if (_mouseMove) {
				_cameraController.panAngle = 0.3*(stage.mouseX - _prevMouseX) + _prevPanAngle;
				_cameraController.tiltAngle = 0.3*(stage.mouseY - _prevMouseY) + _prevTiltAngle;
			}
			
			_cameraController.update();
			
			//update light
			_skyLight.position = _view3D.camera.position;
			
			_view3D.render();
		}
		
		protected function onComplete(event:Event):void
		{
			for each (var sceneData:SceneData in _assetLoader.sceneAssets)
			{
				sceneData.lightPicker = _lightPicker;
				
				//materials
				sceneData.skyMap = _skyMap;
				sceneData.fog = _fog;
				sceneData.specularMethod = _specularMethod;
				sceneData.shadowMethod = _shadowMethod;
				
				//global light setting
				sceneData.sunColor = sunColor;
				sceneData.sunAmbient = sunAmbient;
				sceneData.sunDiffuse = sunDiffuse;
				sceneData.sunSpecular = sunSpecular;
				sceneData.skyColor = skyColor;
				sceneData.skyAmbient = skyAmbient;
				sceneData.skyDiffuse = skyDiffuse;
				sceneData.skySpecular = skySpecular;
				sceneData.fogColor = fogColor;
			}
			
			_assetFactory = new AssetFactory(_view3D, _physicsWorld, _assetLoader);
			
			_assetFactory.addScene(0);
			
			_assetFactory.addCar(0, 0);
			
			//generate cube texture for sky
			_skyMap = new BitmapCubeTexture(
				Cast.bitmapData(_assetLoader.imageAssets[0]), Cast.bitmapData(_assetLoader.imageAssets[3]),
				Cast.bitmapData(_assetLoader.imageAssets[1]), Cast.bitmapData(_assetLoader.imageAssets[4]),
				Cast.bitmapData(_assetLoader.imageAssets[2]), Cast.bitmapData(_assetLoader.imageAssets[5])
			);
			
			//create the skybox
			_view3D.scene.addChild(new SkyBox(_skyMap));
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