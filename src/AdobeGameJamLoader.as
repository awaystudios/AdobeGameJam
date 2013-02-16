package
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import potato.modules.navigation.ViewLoader;
	import potato.modules.navigation.presets.YAMLLoaderView;
	
	import views.SplashView;
	
	[SWF(width="1280", height="420", frameRate="60", backgroundColor="#000000")]
	public class AdobeGameJamLoader extends YAMLLoaderView
	{
		public function AdobeGameJamLoader ()
		{
			SplashView;
			super();
		}
		
		override public function init():void
		{
			var vl:ViewLoader = loaderFor("main");
			vl.addEventListener(ProgressEvent.PROGRESS, _onViewLoadProgress);
			vl.addEventListener(Event.COMPLETE, onMainLoadComplete);
			vl.start();
			
			addView("splash");
		}
		
		public function onMainLoadComplete(e:Event):void
		{
			e.target.addEventListener(ProgressEvent.PROGRESS, _onViewLoadProgress);
			e.target.removeEventListener(Event.COMPLETE, onMainLoadComplete);
			
			//ServiceManager.instance.registerParser(new JSONResponseParser());
			//ServiceManager.instance.registerServicesByConfig(parameters);
			
			removeView("splash");
			addView("test"); 
			
			if ( parameters.debug )
			{
				//addChild(FPSMeter.start(this));
			}
		}
		
		private function _onViewLoadProgress ( event : ProgressEvent ) : void 
		{
			try 
			{
//				trace(int(event.bytesLoaded / event.bytesTotal * 100));
				msg("splash").bar.progress = int(event.bytesLoaded / event.bytesTotal * 100);
			}
			catch ( error : Error )
			{
				
			}
		}
	}
}