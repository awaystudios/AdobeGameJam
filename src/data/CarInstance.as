package data
{
	import away3d.containers.*;
	import away3d.entities.*;
	import away3d.materials.*;
	
	import awayphysics.dynamics.*;
	import awayphysics.dynamics.vehicle.*;

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
		
	}
}