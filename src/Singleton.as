package
{

	//import flash.display.Stage;
	
	/**
	*
	*	Singelton
	*	
	*/
	
	public class Singleton
	{
		
		/** 
		*	Init a var for a class
		*/
		
		private static var instance:Singleton;
		private static var allowInstantiation:Boolean;
		public var setSpeed:Function;
		
		
		/**
		*
		*	Instances I want to share 
		*
		*/
		
		public var _stageWidth:uint;		
		public var _stageHeight:uint;
		public var refreshStarling:Function = null;
		
				
		/**
		*	Method to create and access singelton instance
		*/
		
		public static function getInstance():Singleton
		{
			if (instance == null)
			{
				allowInstantiation = true;
				instance = new Singleton();
				allowInstantiation = false;
			}
			return instance;
		}
		
		
		/**
		*	Constructor never use this
		*/ 
		
		public function Singleton():void
		{
			if (!allowInstantiation)
			{
				throw new Error("Error: Instantiation failed: Use Singleton.getInstance() instead of new.");
			}
		}
	}
}