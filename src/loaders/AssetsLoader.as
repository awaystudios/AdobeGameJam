package loaders
{
	import away3d.containers.*;
	import away3d.entities.*;
	import away3d.events.*;
	import away3d.library.assets.*;
	import away3d.loaders.*;
	import away3d.loaders.parsers.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import awayphysics.collision.shapes.*;
	import awayphysics.dynamics.*;
	
	import data.*;

	public class AssetsLoader extends EventDispatcher
	{
		private const _loadingStrings:Vector.<String> = Vector.<String>(["sky/sky_posX.jpg", "sky/sky_posY.jpg", "sky/sky_posZ.jpg", "sky/sky_negX.jpg", "sky/sky_negY.jpg", "sky/sky_negZ.jpg", "camero/interior.jpg", "camero/camaro.AWD", "mercedesSLR/interior.jpg", "mercedesSLR/slr.AWD", "hamburg.AWD"]);
		private var _n:uint = 0;
		private var _bytesLoaded:uint = 0;
		private var _bytesTotal:uint = 0;
		private var _carData:CarData;
		private var _carSubContainer:ObjectContainer3D;
		
		private var assetsRoot:String = "assets/";
		private var loadingURL:String;
		
		public var carAssets:Vector.<CarData> = new Vector.<CarData>();
		
		public var imageAssets:Vector.<Bitmap> = new Vector.<Bitmap>();
		public var sceneAssets:Vector.<SceneData> = new Vector.<SceneData>();
		private var _sceneData:SceneData;
		
		public function AssetsLoader()
		{
			
		}
		
		public function get percentAssetLoaded():Number
		{
			return 100*_n/_loadingStrings.length;
		}
		
		public function get percentBytesLoaded():Number
		{
			return 100*_bytesLoaded/_bytesTotal;
		}
		
		public function startLoading():void
		{
			load(_loadingStrings[0]);
		}
		
		/**
		 * Global binary file loader
		 */
		private function load(url:String):void
		{
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loadingURL = url;
			switch (url.substring(url.length - 3)) {
				case "AWD": 
				case "awd": 
					//_loadingText = "Loading Model";
					loader.addEventListener(Event.COMPLETE, parseAWD, false, 0, true);
					break;
				case "png": 
				case "jpg": 
					//_loadingText = "Loading Textures";
					loader.addEventListener(Event.COMPLETE, parseBitmap);
					break;
			}
			
			loader.addEventListener(ProgressEvent.PROGRESS, loadProgress, false, 0, true);
			var urlReq:URLRequest = new URLRequest(assetsRoot+url);
			loader.load(urlReq);
			
		}
		
		
		/**
		 * Display current load
		 */
		private function loadProgress(e:ProgressEvent):void
		{
			var P:int = int(e.bytesLoaded / e.bytesTotal * 100);
			/*
			if (P != 100) {
				_text.text = "Load : " + P + " % | " + int((e.bytesLoaded / 1024) << 0) + " KB";
			} else {
				_text.text = "Cursor keys / WSAD / ZSQD - move\n";
				_text.appendText("SHIFT - boost\n");
				_text.appendText("SPACE - brake\n");
				_text.appendText("R - restart\n");
			}
			*/
			
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
		}
		
		/**
		 * Load AWD
		 */
		private function parseAWD(e:Event):void
		{
			switch (loadingURL) {
				case "camero/camaro.AWD":
				case "mercedesSLR/slr.AWD":
					_carData = new CarData();
					carAssets.push(_carData);
					break;
				default:
					_sceneData = new SceneData();
					sceneAssets.push(_sceneData);
			}
			
			var loader:URLLoader = e.target as URLLoader;
			var loader3d:Loader3D = new Loader3D(false);
			
			loader3d.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete, false, 0, true);
			loader3d.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete, false, 0, true);
			loader3d.loadData(loader.data, null, null, new AWD2Parser());
			
			loader.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
			loader.removeEventListener(Event.COMPLETE, parseAWD);
		}
		
		/**
		 * Parses the Bitmap file
		 */
		private function parseBitmap(e:Event):void 
		{
			var urlLoader:URLLoader = e.target as URLLoader;
			var loader:Loader = new Loader();
			loader.loadBytes(urlLoader.data);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBitmapComplete, false, 0, true);
			urlLoader.removeEventListener(Event.COMPLETE, parseBitmap);
			urlLoader.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
			loader = null;
		}
		
		/**
		 * Listener function for bitmap complete event on loader
		 */
		private function onBitmapComplete(e:Event):void
		{
			var loader:Loader = LoaderInfo(e.target).loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onBitmapComplete);
			
			imageAssets.push(e.target.content);
			
			loader.unload();
			loader = null;
			
			_n++;
			
			if (_n < _loadingStrings.length)
				load(_loadingStrings[_n]);
		}
		
		/**
		 * Listener for asset complete
		 */
		private function onAssetComplete(event:AssetEvent):void
		{
			if (event.asset.assetType == AssetType.MESH) {
				var mesh:Mesh = event.asset as Mesh;
				var sc:Number = 50;
				trace(loadingURL);
				switch (loadingURL) {
					case "camero/camaro.AWD":
					case "mercedesSLR/slr.AWD":
						switch (mesh.name) {
							case "body":
								mesh.scale(sc);
								//the main car body
								mesh.x = mesh.x*sc;
								mesh.y = mesh.y*sc;
								mesh.z = mesh.z*sc;
								mesh.castsShadows = true;
								_carData.bodyMesh = mesh;
								break;
							case "glass":
								mesh.scale(sc);
								//the main car bodyq
								mesh.x = mesh.x*sc;
								mesh.y = mesh.y*sc;
								mesh.z = mesh.z*sc;
								mesh.castsShadows = true;
								_carData.glass = mesh;
								break;
							case "bumper":
								mesh.scale(sc);
								//the main car body
								mesh.x = mesh.x*sc;
								mesh.y = mesh.y*sc;
								mesh.z = mesh.z*sc;
								mesh.castsShadows = true;
								_carData.bumper = mesh;
								break;
							case "interior":
								mesh.scale(sc);
								//the main car body
								mesh.x = mesh.x*sc;
								mesh.y = mesh.y*sc;
								mesh.z = mesh.z*sc;
								mesh.castsShadows = true;
								_carData.interior = mesh;
								break;
							case "wheelFR":
								mesh.scale(sc);
								// the wheel used to create our 4 dynamic wheels
								//mesh.material = textureMaterials[3];
								_carData.wheelMeshFR = mesh;
								break;
							case "wheelFL":
								mesh.scale(sc);
								// the wheel used to create our 4 dynamic wheels
								//mesh.material = textureMaterials[3];
								_carData.wheelMeshFL = mesh;
								break;
							case "wheelBR":
								mesh.scale(sc);
								// the wheel used to create our 4 dynamic wheels
								//mesh.material = textureMaterials[3];
								_carData.wheelMeshBR = mesh;
								break;
							case "wheelBL":
								mesh.scale(sc);
								// the wheel used to create our 4 dynamic wheels
								//mesh.material = textureMaterials[3];
								_carData.wheelMeshBL = mesh;
								break;
							case "headLight":
								//mesh.material = textureMaterials[5];
								break;
							case "hood":
							case "bottomCar":
								//mesh.material = textureMaterials[0];
								break;
							case "carShape":
								mesh.scale(sc);
								mesh.x = mesh.x*sc;
								mesh.y = mesh.y*sc;
								mesh.z = mesh.z*sc;
								mesh.geometry.applyTransformation(mesh.transform);
								//! invisible : physics car collision shape 
								mesh.castsShadows = false;
								_carData.carShape = mesh.geometry;
						}
						break;
					case "hamburg.AWD":	
						var sceneBody:AWPRigidBody;
						var trackScale:Number = 5;
						
						if (mesh.name == "track")
							mesh.rotationX = 180;
						mesh.geometry.applyTransformation(mesh.transform);
						mesh.geometry.scale(trackScale);
						mesh.rotationX = 0;
						switch (mesh.name) {
							case "track":
								//add mesh to view
								_sceneData.sceneMesh = mesh;
								// create triangle mesh shape for mesh
								_sceneData.sceneBody = new AWPRigidBody(new AWPBvhTriangleMeshShape(mesh.geometry), mesh);
								break;
							case "wall":
								//add mesh to view
								_sceneData.sceneWall = mesh;
								// create triangle mesh shape for mesh
								_sceneData.sceneWallBody = new AWPRigidBody(new AWPBvhTriangleMeshShape(mesh.geometry), mesh);
								break;
							case "zone07":
								//add mesh to view
								_sceneData.sceneZone07 = mesh;
								// create triangle mesh shape for mesh
								_sceneData.sceneZone07Body = new AWPRigidBody(new AWPBvhTriangleMeshShape(mesh.geometry), mesh);
								break;
							case "zone06":
								//add mesh to view
								_sceneData.sceneZone06 = mesh;
								// create triangle mesh shape for mesh
								_sceneData.sceneZone06Body = new AWPRigidBody(new AWPBvhTriangleMeshShape(mesh.geometry), mesh);
								break;
							default:
						}
						break;
				}
			}
		}
		
		/**
		 * Listener for resource complete
		 */
		private function onResourceComplete(e:LoaderEvent):void
		{
			
			var loader3d:Loader3D = e.target as Loader3D;
			loader3d.removeEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			loader3d.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			
			_n++;
			
			if (_n < _loadingStrings.length)
				load(_loadingStrings[_n]);
			else
				dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}