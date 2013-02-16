package loaders
{
	import away3d.containers.*;
	import away3d.entities.*;
	import away3d.materials.*;
	
	import flash.geom.*;
	
	import awayphysics.collision.dispatch.*;
	import awayphysics.collision.shapes.*;
	import awayphysics.dynamics.*;
	import awayphysics.dynamics.vehicle.*;
	
	import data.*;

	public class AssetFactory
	{
		private var _view3D:View3D;
		private var _physicsWorld:AWPDynamicsWorld;
		private var _assetLoader:AssetsLoader;
		
		public function AssetFactory(view3D:View3D, physicsWorld:AWPDynamicsWorld, assetLoader:AssetsLoader )
		{
			_view3D = view3D;
			_physicsWorld = physicsWorld;
			_assetLoader = assetLoader;
		}
		
		public function setBodyColor(carInstance:CarInstance, color:uint):void
		{
			carInstance.bodyMaterial.color = color;
		}
		
		public function setRimColor(carInstance:CarInstance, color:uint):void
		{
			carInstance.rimMaterial.color = color;
		}
		
		public function addScene(id:uint):SceneInstance
		{
			var sceneData:SceneData = _assetLoader.sceneAssets[id];
			
			var sceneInstance:SceneInstance = new SceneInstance();
			sceneInstance.data = sceneData;
			
			//add to scene
			var sceneMesh:Mesh = sceneData.sceneMesh;
			_view3D.scene.addChild(sceneMesh);
			var sceneWall:Mesh = sceneData.sceneMesh;
			_view3D.scene.addChild(sceneWall);
			var sceneZone06:Mesh = sceneData.sceneZone06;
			_view3D.scene.addChild(sceneZone06);
			var sceneZone07:Mesh = sceneData.sceneZone07;
			_view3D.scene.addChild(sceneZone07);
			
			// add to world physics
			var sceneBody:AWPRigidBody = sceneData.sceneBody;
			_physicsWorld.addRigidBody(sceneBody);
			var sceneWallBody:AWPRigidBody = sceneData.sceneWallBody;
			_physicsWorld.addRigidBody(sceneWallBody);
			var sceneZone06Body:AWPRigidBody = sceneData.sceneZone06Body;
			_physicsWorld.addRigidBody(sceneZone06Body);
			var sceneZone07Body:AWPRigidBody = sceneData.sceneZone07Body;
			_physicsWorld.addRigidBody(sceneZone07Body);
			
			
			var material:SinglePassMaterialBase = new ColorMaterial(0x999999);
			material.lightPicker = sceneData.lightPicker;
			material.shadowMethod = sceneData.shadowMethod;
			material.specular = 0;
			
			//assign materials
			sceneMesh.material = material;
			sceneWall.material = material;
			
			material = new ColorMaterial(0x666666);
			material.specular = 0;
			material.lightPicker = sceneData.lightPicker;
			material.shadowMethod = sceneData.shadowMethod;
			
			sceneZone06.material = material;
			sceneZone07.material = material;

			
			return sceneInstance;
		}
		
		public function addCar(id:uint, sceneID:uint):CarInstance
		{
			var sceneData:SceneData = _assetLoader.sceneAssets[sceneID];
			
			var carData:CarData = _assetLoader.carAssets[id];
			var carInstance:CarInstance = new CarInstance();
			var carContainer:ObjectContainer3D = carInstance.carContainer = new ObjectContainer3D();
			var carSubContainer:ObjectContainer3D = new ObjectContainer3D();
			carSubContainer.rotationY = 180;
			carSubContainer.addChild(carInstance.bodyMesh = carData.bodyMesh.clone() as Mesh);
			carContainer.addChild(carSubContainer);
			_view3D.scene.addChild(carContainer);
			
			_view3D.scene.addChild(carInstance.wheelFR = carData.wheelMeshFR.clone() as Mesh);
			_view3D.scene.addChild(carInstance.wheelFL = carData.wheelMeshFL.clone() as Mesh);
			_view3D.scene.addChild(carInstance.wheelBR = carData.wheelMeshBR.clone() as Mesh);
			_view3D.scene.addChild(carInstance.wheelBL = carData.wheelMeshBL.clone() as Mesh);
			
			// create the chassis body
			var carBody:AWPRigidBody = new AWPRigidBody(new AWPConvexHullShape(carData.carShape), carContainer, 1000);
			carBody.activationState = AWPCollisionObject.DISABLE_DEACTIVATION;
			phySetting(carBody, 0.5, 0.0, 0.3, 0.3);
			
			carInstance.carBody = carBody;
			
			// add to world physics
			_physicsWorld.addRigidBody(carBody);
			
			// setup vehicle tuning
			var tuning:AWPVehicleTuning = new AWPVehicleTuning();
			tuning.frictionSlip = 2;
			tuning.suspensionStiffness = 100;
			tuning.suspensionDamping = 0.85;
			tuning.suspensionCompression = 0.83;
			tuning.maxSuspensionTravelCm = 10;
			tuning.maxSuspensionForce = 10000;
			
			//create a new car physics object
			var carVehicle:AWPRaycastVehicle = new AWPRaycastVehicle(tuning, carBody)
			_physicsWorld.addVehicle(carVehicle);
			
			carInstance.carVehicle = carVehicle;
			
			// wheels setting
			carVehicle.addWheel(carInstance.wheelFR, new Vector3D(42, 28, 74), new Vector3D(0, -1, 0), new Vector3D(-1, 0, 0), 5, 17, tuning, true);
			carVehicle.addWheel(carInstance.wheelFL, new Vector3D(-42, 28, 74), new Vector3D(0, -1, 0), new Vector3D(-1, 0, 0), 5, 17, tuning, true);
			carVehicle.addWheel(carInstance.wheelBR, new Vector3D(42, 28, -67), new Vector3D(0, -1, 0), new Vector3D(-1, 0, 0), 5, 17, tuning, false);
			carVehicle.addWheel(carInstance.wheelBL, new Vector3D(-42, 28, -67), new Vector3D(0, -1, 0), new Vector3D(-1, 0, 0), 5, 17, tuning, false);
			
			// wheels settings
			for (var i:int = 0; i < carVehicle.getNumWheels(); i++) {
				var wheel:AWPWheelInfo = carVehicle.getWheelInfo(i);
				wheel.wheelsDampingRelaxation = 4.5;
				wheel.wheelsDampingCompression = 4.5;
				wheel.suspensionRestLength1 = 10;
				wheel.rollInfluence = 0.2;
			}
			
			var material:SinglePassMaterialBase;
			
			//create body material
			carInstance.bodyMesh.material = material = carInstance.bodyMaterial = new ColorMaterial(0xFF0000);
			material.lightPicker = sceneData.lightPicker;
			
			//create rim material
			material = carInstance.rimMaterial = new ColorMaterial(0x00FF00);
			material.lightPicker = sceneData.lightPicker;
			(carInstance.wheelBL.getChildAt(0) as Mesh).material = material;
			(carInstance.wheelBR.getChildAt(0) as Mesh).material = material;
			(carInstance.wheelFL.getChildAt(0) as Mesh).material = material;
			(carInstance.wheelFR.getChildAt(0) as Mesh).material = material;
			
			//create wheel material
			material = new ColorMaterial(0x333333);
			material.lightPicker = sceneData.lightPicker;
			carInstance.wheelBL.material = material;
			carInstance.wheelBR.material = material;
			carInstance.wheelFL.material = material;
			carInstance.wheelFR.material = material;
			
			return carInstance;
		}
		
		public function removeCar(carInstance:CarInstance):void
		{
			_physicsWorld.removeVehicle(carInstance.carVehicle);
			_physicsWorld.removeRigidBody(carInstance.carBody);
			
			_view3D.scene.removeChild(carInstance.wheelFR);
			_view3D.scene.removeChild(carInstance.wheelFL);
			_view3D.scene.removeChild(carInstance.wheelBR);
			_view3D.scene.removeChild(carInstance.wheelBL);
			_view3D.scene.removeChild(carInstance.carContainer);
		}
		
		
		
		/**
		 * Physics base setting
		 */
		private function phySetting(body:AWPRigidBody, f:Number=0.5, r:Number=0, ld:Number=0, la:Number=0):void {
			body.friction = f;
			body.restitution = r;
			body.linearDamping = ld;
			body.angularDamping = la;
		}
	}
}