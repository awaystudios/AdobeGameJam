package
{
	import away3d.core.managers.Stage3DProxy;
	
	import starling.core.Starling;

	public class User
	{
		static public var selectedCarIndex:int = 0;
		static public var bodyColor:uint = 0xFF0000;
		static public var rimsColor:uint = 0xFF0000;
		
		static public var sharedStage3DProxy:Stage3DProxy;
		static public var starling:Starling;
		static public var hud:Hud;
	}
}