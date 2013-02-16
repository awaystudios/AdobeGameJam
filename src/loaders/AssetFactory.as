package loaders
{
	import away3d.containers.*;
	import away3d.entities.*;
	import away3d.loaders.*;
	
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
		private var _assetLoader:AssetLoader;
		
		public function AssetFactory(view3D:View3D, physicsWorld:AWPDynamicsWorld, assetLoader:AssetLoader )
		{
			_view3D = view3D;
			_physicsWorld = physicsWorld;
			_assetLoader = assetLoader;
		}
		
		public function setBodyColor(carInstance:CarInstance, color:uint):void
		{
			
		}
		
		public function setRimColor(carInstance:CarInstance, color:uint):void
		{
			
		}
		
		public function addCar(id:uint):CarInstance
		{
			var carData:CarData = _assetLoader[id];
			var carInstance:CarInstance = new CarInstance();
			var carContainer:ObjectContainer3D = new ObjectContainer3D();
			carInstance.carContainer = new ObjectContainer3D();
			var carSubContainer:ObjectContainer3D = new ObjectContainer3D();
			carSubContainer.rotationY = 180;
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
			carVehicle.addWheel(carData.wheelMeshFR, new Vector3D(42, 28, 74), new Vector3D(0, -1, 0), new Vector3D(-1, 0, 0), 5, 17, tuning, true);
			carVehicle.addWheel(carData.wheelMeshFL, new Vector3D(-42, 28, 74), new Vector3D(0, -1, 0), new Vector3D(-1, 0, 0), 5, 17, tuning, true);
			carVehicle.addWheel(carData.wheelMeshBR, new Vector3D(42, 28, -67), new Vector3D(0, -1, 0), new Vector3D(-1, 0, 0), 5, 17, tuning, false);
			carVehicle.addWheel(carData.wheelMeshBL, new Vector3D(-42, 28, -67), new Vector3D(0, -1, 0), new Vector3D(-1, 0, 0), 5, 17, tuning, false);
			
			// wheels settings
			for (var i:int = 0; i < carVehicle.getNumWheels(); i++) {
				var wheel:AWPWheelInfo = carVehicle.getWheelInfo(i);
				wheel.wheelsDampingRelaxation = 4.5;
				wheel.wheelsDampingCompression = 4.5;
				wheel.suspensionRestLength1 = 10;
				wheel.rollInfluence = 0.2;
			}
			
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