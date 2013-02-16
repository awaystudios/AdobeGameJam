package
{
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.extensions.ClippedSprite;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	public class Map extends Sprite
	{
		
		[Embed(source="/media/track_line.jpg", mimeType="image/jpeg")]
		private var tracklineEmbed:Class;
		private var trackline:ClippedSprite;
		public var w:int = 0;
		public var h:int = 0;
		public var maskPosX:int = 0;
		public var maskPosY:int = 0;
		private var pos:Quad;
		
		public function Map()
		{			
			pos = new Quad(20,20,Color.RED);
			trackline = new ClippedSprite();
			trackline.addChild(Image.fromBitmap(new tracklineEmbed()));
			
			addChild(trackline);
			addChild(pos);
		}
		
		public function addMask(width:int,height:int){
			w = width;
			h = height;
			setFilter(w/2,h/2);
		}
		
		private function setFilter(x:int,y:int){
			//trackline.filter = new CircleMaskFilter(100,100,100);
			//trackline.filter = new CircleMaskFilter(w/2,x,y);
			trackline.clipRect = new Rectangle(x,y,w,h);
			maskPosX=x;
			maskPosY=y;
			pos.x = x+w/2;
			pos.y = y+h/2;
		}
		
		public function setPos(x:int,y:int){
			setFilter(x,y);
		}
	}
}