package data
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	
	import awayphysics.dynamics.AWPRigidBody;
	import awayphysics.dynamics.vehicle.AWPRaycastVehicle;
	import awayphysics.dynamics.vehicle.AWPWheelInfo;

	public class CarInstance
	{
		public var carContainer:ObjectContainer3D;
		
		public var bodyMesh:Mesh;
		
		public var wheelFR:Mesh;
		
		public var wheelFL:Mesh;
		
		public var wheelBR:Mesh;
		
		public var wheelBL:Mesh;
		public var carVehicle:AWPRaycastVehicle;
		public var carBody:AWPRigidBody;
		
		//materials
		public var bodyMaterial:ColorMaterial;
		public var rimMaterial:ColorMaterial;
		
		public var keyLeft:Boolean = false;
		public var keyRight:Boolean = false;
		public var steering:Number = 0
		public var engineForce:Number = 0;
		public var breaking:Number = 0;
			
		public function step():void{
			if (keyLeft) {
				steering -= 0.03;
				if (steering < -Math.PI / 6)
					steering = -Math.PI / 6;
			}
			
			if (keyRight) {
				steering += 0.03;
				if (steering > Math.PI / 6)
					steering = Math.PI / 6;
			}
			
			// apply the force to the car
			carVehicle.applyEngineForce(engineForce, 0);
			carVehicle.setBrake(breaking, 0);
			carVehicle.applyEngineForce(engineForce, 1);
			carVehicle.setBrake(breaking, 1);
			carVehicle.applyEngineForce(engineForce, 2);
			carVehicle.setBrake(breaking, 2);
			carVehicle.applyEngineForce(engineForce, 3);
			carVehicle.setBrake(breaking, 3);
			carVehicle.setSteeringValue(steering, 0);
			carVehicle.setSteeringValue(steering, 1);
			steering *= 0.9;
		
		}
		
		public function update(ba:ByteArray):void
		{
			//return
			ba.position = 0;
			
			var keyLeft:Boolean = ba.readBoolean()
			var keyRight:Boolean = ba.readBoolean();
			
			var engineForce:Number = ba.readFloat()
			var breakingForce:Number = ba.readFloat()
			var vehicleSteering:Number = ba.readFloat()
			
			var position:Vector3D = readVector3D(ba);
			var rotation:Vector3D= readVector3D(ba); 
			var linearVelocity:Vector3D= readVector3D(ba);
			var angularVelocity:Vector3D= readVector3D(ba);
			
			var position1:Vector3D= readVector3D(ba);
			var rotation1:Number  = ba.readFloat()
			var deltaRotation1:Number  = ba.readFloat()
			
			var position2:Vector3D= readVector3D(ba);
			var rotation2:Number  = ba.readFloat()
			var deltaRotation2:Number  = ba.readFloat()
			
			var position3:Vector3D= readVector3D(ba);
			var rotation3:Number  = ba.readFloat()
			var deltaRotation3:Number = ba.readFloat() 
			
			var position4:Vector3D= readVector3D(ba);
			var rotation4:Number  = ba.readFloat()
			var deltaRotation4:Number  = ba.readFloat()
			
			//Set modifiers
			keyLeft = keyLeft;
			keyRight = keyRight;
			
			//apply input
			engineForce = engineForce;
			breaking = breakingForce;
			steering = vehicleSteering;
			
			
			//apply rigidbody state
			var body2:AWPRigidBody = carVehicle.getRigidBody();
			
			var offset:Vector3D = position.subtract(body2.position)
			
			if(offset.length > 200){
				body2.position = position
			}else{
				offset.scaleBy(Math.max(Math.min(offset.length/200,1),.1));
				body2.position = body2.position.add(offset)
			}
			
			
			
			body2.rotation = rotation;
			body2.linearVelocity = linearVelocity;
			body2.angularVelocity = angularVelocity;
			
			var wheel0:AWPWheelInfo = carVehicle.getWheelInfo(0);
			wheel0.worldPosition = position1;
			wheel0.rotation = rotation1;
			wheel0.deltaRotation = deltaRotation1;
			
			var wheel1:AWPWheelInfo = carVehicle.getWheelInfo(1);
			wheel1.worldPosition = position2;
			wheel1.rotation = rotation2;
			wheel1.deltaRotation = deltaRotation2;
			
			var wheel2:AWPWheelInfo = carVehicle.getWheelInfo(2);
			wheel2.worldPosition = position3;
			wheel2.rotation = rotation3;
			wheel2.deltaRotation = deltaRotation3;
			
			var wheel3:AWPWheelInfo = carVehicle.getWheelInfo(3);
			wheel3.worldPosition = position4;
			wheel3.rotation = rotation4;
			wheel3.deltaRotation = deltaRotation4;
			
		}
		
		private function readVector3D(ba:ByteArray):Vector3D{
			return new Vector3D(ba.readFloat(),ba.readFloat(),ba.readFloat(),0); 
		}
		
		
	}
}