package views
{
	import flash.display.Bitmap;
	
	import potato.modules.navigation.View;
	
	import ui.ProgressBar;
	
	public class SplashView extends View
	{
		[Embed(source="../../assets/img/gamejamhamburg.png")] 
		private var _logoSrc:Class;
		
		public var logo:Bitmap;
		public var bar:ProgressBar;
		
		//public function SplashView ()
		//{
		//	init();
		//}
		
		override public function init():void
		{
			logo = new _logoSrc() as Bitmap;
			logo.scaleX = logo.scaleY = .25;
			
			bar = new ProgressBar(logo.width,50);
			bar.y = logo.height + 10;
			
			addChild(logo);
			addChild(bar);
		}
	}
}