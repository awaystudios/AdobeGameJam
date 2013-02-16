package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import views.*;
	
	[SWF(width="1280", height="420", frameRate="60", backgroundColor="#000000")]
	public class AdobeGameJam extends Sprite
	{
		public function AdobeGameJam()
		{
			GarageView;
			GameView;
			LobbyView;
		}
	}
}