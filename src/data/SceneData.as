package data
{
	import away3d.entities.*;
	import away3d.lights.*;
	import away3d.materials.lightpickers.*;
	import away3d.materials.methods.*;
	import away3d.textures.*;
	
	import awayphysics.dynamics.*;

	public class SceneData
	{

		public var sceneMesh:Mesh;
		public var sceneBody:AWPRigidBody;
		
		//light variables
		public var sunLight:DirectionalLight;
		public var skyLight:PointLight;
		public var lightPicker:StaticLightPicker;
		
		//materials
		public var skyMap:BitmapCubeTexture;
		public var fog:FogMethod;
		public var specularMethod:FresnelSpecularMethod;
		public var shadowMethod:NearShadowMapMethod;
		
		//global light setting
		public var sunColor:uint = 0xAAAAA9;
		public var sunAmbient:Number = 0.4;
		public var sunDiffuse:Number = 0.5;
		public var sunSpecular:Number = 1;
		public var skyColor:uint = 0x333338;
		public var skyAmbient:Number = 0.2;
		public var skyDiffuse:Number = 0.3;
		public var skySpecular:Number = 0.5;
		public var fogColor:uint = 0x333338;
		public var sceneWall:Mesh;
		public var sceneWallBody:AWPRigidBody;
		public var sceneZone06:Mesh;
		public var sceneZone06Body:AWPRigidBody;
		public var sceneZone07Body:AWPRigidBody;
		public var sceneZone07:Mesh;
	}
}