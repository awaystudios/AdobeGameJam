package
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	
	import flash.display.Bitmap;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.deg2rad;
	
	
	public class Hud extends Sprite
	{
		[Embed(source="/media/speedometer.png", mimeType="image/png")]
		private var speedometerEmbed:Class;
		private var speedometer:Image;
		private var speedometerOriginalW:int;
		private var speedometerOriginalH:int;
		private var speedometerMarginBottom:int = 0;
		private var speedometerMarginRight:int = 0;
		
		[Embed(source="/media/Arial.ttf", embedAsCFF="false", fontFamily="Arial")]
		private static const Arial:Class;
		
		[Embed(source="/media/Korataki.ttf", embedAsCFF="false", fontFamily="Korataki")]
		private static const Korataki:Class;

		[Embed(source="/media/Arialbd.ttf", embedAsCFF="false", fontFamily="Arial", fontWeight="bold")]
		private static const ArialBold:Class;

		private var trackline:Map;
		
		[Embed(source="/media/arrow.png", mimeType="image/png")]
		private var arrowEmbed:Class;
		private var arrow:Image;
		private var arrowOriginalW:int;
		private var arrowOriginalH:int;
		private var arrowPosXCorrection:Number;
		private var arrowPosYCorrection:Number;
		private var arrowRootCorrectionX:Number;
		private var arrowRootCorrectionY:Number;
		private var arrowRotation:Number = 0;
		private var arrowRotationStart:Number = 0;
		private var arrowRotationMax:Number = 220;
		private var drive:Number = 0;
		private var driveGainTime:Number = 0.5;
		private var driveFastDropTime:Number = 0.5;
		private var driveDropTime:Number = 4;
		private var mapMoveTime:Number=2;
		
		private var fontSize:int=12;
		
		private var speedText:TextField;
		private var speedTextShadow:TextField;
		private var _speedTextCorrectionX:Number = -30;
		private var speedTextCorrectionX:Number = -30;
		private var speedTextCorrectionY:Number = 0;
		
		private var lapText:TextField;
		private var lapTextShadow:TextField;
		private var lapTextCorrectionX:Number = -30;
		private var lapTextCorrectionY:Number = 0;
		
		private var positionText:TextField;
		private var positionTextShadow:TextField;
		
		public var tweenedValue:Number = 0;
		
		private var speed:Number=0;
		private var speedMax:Number=350;
		private var gear:int=1;
		private var gearMaxSpeed:int = 60;
		private var gearMax:int=6;
		
		private var player:starling.display.Quad;
		
		private var w:int;
		private var h:int;
		
		private var lap:int = 1;
		private var position:int = 1;
		private var trackw:int;
		private var trackh:int;
		
		private var speedometerMargin:Array;
		public function Hud()
		{
			super();
			
			var s:Bitmap = new speedometerEmbed();
			speedometer = Image.fromBitmap(s);
			
			s = new arrowEmbed();
			arrow = Image.fromBitmap(s);
			
			trackline = new Map();
			
			addChild(trackline);
			
			player = new starling.display.Quad(10,10,Color.RED);
			addChild(player);
			
			arrowPosXCorrection = 3.4;
			arrowPosYCorrection = 5.1;
			arrowRootCorrectionX = 0;
			arrowRootCorrectionY = -2;
			Singleton.getInstance().setSpeed = setSpeed;
			trace('hud initialized');

			addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		
		private function init():void{
			initTrack(0.18*this.stage.stageWidth,0.18*this.stage.stageWidth);
			addChild(speedometer);
			addChild(arrow);
			
			this.speedometerOriginalH = speedometer.height;
			this.speedometerOriginalW = speedometer.width;
			
			this.arrowOriginalW = arrow.width;
			this.arrowOriginalH = arrow.height;
			
			h = this.stage.stageHeight;
			w = this.stage.stageWidth;
			
			fontSize  = w/50;
			if(fontSize<5)
				fontSize = 5;
			if( fontSize>20)
				fontSize=20;

			speedText = new TextField(0.1*this.stage.stageWidth, 20, "", "Korataki", fontSize, Color.WHITE);
			speedText.alpha = 0.8;
			
			speedTextShadow = new TextField(0.1*this.stage.stageWidth, 20, "", "Korataki", fontSize, Color.BLACK);
			speedTextShadow.alpha = 0.8;
			
		
			
			lapText = new TextField(speedText.width*2, 20, lap.toString(), "Korataki", fontSize, Color.WHITE);
			lapText.alpha = 0.8;
			
			lapTextShadow = new TextField(speedText.width*2, 20, lap.toString(), "Korataki", fontSize, Color.BLACK);
			lapTextShadow.alpha = 0.8;
			
			positionText = new TextField(speedText.width*2, 20, lap.toString(), "Korataki", fontSize, Color.WHITE);
			positionText.alpha = 0.8;
			
			positionTextShadow = new TextField(speedText.width*2, 20, lap.toString(), "Korataki", fontSize, Color.BLACK);
			positionTextShadow.alpha = 0.8;
			
			this.setLap(1);
			this.setPosition(1);
			
			//textField.hAlign = HAlign.RIGHT;  // horizontal alignment
			//textField.vAlign = VAlign.BOTTOM; // vertical alignment
			addChild(speedTextShadow);
			addChild(speedText);
			
			addChild(lapTextShadow);
			addChild(lapText);
			
			addChild(positionTextShadow);
			addChild(positionText);

			trace('set margins');
			this.setSpeedometerMargins(3,5);
			trace('set track pos');
			setTrackPos(0,0,false);
			trace('set size');
			this.setSpeedometerWidth(20);
			
			addEventListener(Event.ENTER_FRAME, loop);
			
			arrowRotation = arrowRotationStart;
			arrow.rotation = starling.utils.deg2rad(arrowRotationStart);

		}
		
		
		
		private function setSpeedometerDimensions(factor:Number):void{
			trace('x = ' + factor);
			this.speedometer.height *= factor;
			this.speedometer.width *= factor;
			//this.speedText.scaleX = factor/2;
			//this.speedText.scaleY = factor/2;
			//speedTextCorrectionX = _speedTextCorrectionX * factor;
			//this.speedTextCorrectionX 
			this.arrow.height *=factor;
			this.arrow.width *= factor;
			this.arrow.pivotX = this.arrow.width/factor/2 + (this.arrow.width/factor)*(arrowRootCorrectionX/100);
			
			
			//this.speedText.
			//this.arrow.pivotY = (this.arrow.height/factor)*(arrowRootCorrectionY/100);
			setMargins();
		}
						
		private function setMargins():void{
			h = this.stage.stageHeight;
			w = this.stage.stageWidth;

			this.speedometer.x = w - w*(speedometerMarginRight/100) - this.speedometer.width;
			this.speedometer.y = h - h*(speedometerMarginBottom/100) - this.speedometer.height;

			this.arrow.x = this.speedometer.x + this.speedometer.width/2 + this.speedometer.width*(arrowPosXCorrection/100);
			this.arrow.y = this.speedometer.y + this.speedometer.height/2 + this.speedometer.height*(arrowPosYCorrection/100);
			this.speedText.x = speedometer.x + speedText.width;
			this.speedText.y = speedometer.y+speedometer.height/2;
			this.speedTextShadow.x = this.speedText.x+1;
			this.speedTextShadow.y = this.speedText.y+1;
			this.lapText.x = w-this.speedometer.x-this.speedometer.width;
			this.lapText.y = w-this.speedometer.x-this.speedometer.width;
			this.lapTextShadow.x = this.lapText.x+1;
			this.lapTextShadow.y = this.lapText.y+1;
			this.positionText.x = this.lapText.x;
			this.positionText.y = this.lapText.y + this.lapText.height*2;
			this.positionTextShadow.x = this.positionText.x+1;
			this.positionTextShadow.y = this.positionText.y+1;
			var tY:int = h - h*(speedometerMarginBottom/100) - this.trackline.h;
			var tX:int = h -tY - this.trackline.h;
			this.trackline.setPos(tX,tY);
			player.x = tX+trackline.w/2-player.height/2;
			player.y = tY+trackline.h/2-player.width/2;
			
//			trace('w,h -> x,y,w,h: ' + w + ',' + h + ' -> ' + this.speedometer.x + ',' + this.speedometer.y + ',' + this.speedometer.width + ',' + this.speedometer.height); 
		}
		
		
		
		private function loop(e:EnterFrameEvent):void{
			if( w != this.stage.stageWidth || h != this.stage.stageHeight ){
				this.setMargins();
			}
			
			if( speed <= speedMax ){
				this.speed = speed;
				var drive:int = ((speed/gear)/gearMaxSpeed)/Math.abs(Math.sin(gear))*100;
				if( drive > 100 ){
					gear++;
					drive = ((speed/gear)/gearMaxSpeed)/Math.abs(Math.sin(gear))*100;
				}
				if( gear > gearMax )
					gear--;
				
				//trace('speed, gear, drive -> ' + speed+', '+gear+', '+drive);
				setDrive(drive,driveGainTime,driveFastDropTime);
			}
			arrow.rotation = starling.utils.deg2rad(arrowRotationMax*((tweenedValue)/100));
			//setDrive(drive+0.05);
		}
		
		
		public function setDrive(value:Number,gainTime:Number=0,dropTime:Number=0):void{ //from 0 - 100
			if( value < 0 || value > 100 || value == drive )
				return;
			
			if( dropTime == 0 )
				dropTime = driveDropTime;
			if( gainTime == 0 )
				gainTime = ( value > tweenedValue ) ? driveGainTime : dropTime;

			
			TweenLite.killTweensOf(this);
			TweenLite.to(this, gainTime, { 
				tweenedValue:value,
				ease: Bounce,
				onComplete: function():void{
					TweenLite.to(this,dropTime,{
						tweenValue:0,
						ease:Bounce
					});
				}
			});
		}

		public function initTrack(w:int,h:int):void{
			trackw=w;
			trackh=h;
			trackline.addMask(w,h);
			
		}
		
		public function setTrackPos(x:int,y:int,tweening:Boolean=true):void{
			trace('in ' + x +','+y);
			if( x < 0 )
				x = 0;
			if( y < 0 )
				y = 0;
			trace('trackline width,height,w,h ' + trackline.width+','+trackline.height+','+trackline.w+','+trackline.h);
			if( x > trackline.width - trackline.w )
				x = trackline.width - trackline.w;
			if( y > trackline.height - trackline.h )
				y = trackline.height - trackline.h;
			trace('out ' + x +','+y);
			x = this.trackline.maskPosX - x;
			y = this.trackline.maskPosY - y;
			
			if( tweening ){
				TweenLite.killTweensOf(this.trackline);
				TweenLite.to(this.trackline, mapMoveTime, {
					x: x,
					y: y
				});
			}else{
				this.trackline.x = x;
				this.trackline.y = y;
			}
		}
		
		public function setLap(value:int):void{
			lap = value;
			this.lapText.text = 'LAP ' + value.toString();
			this.lapTextShadow.text = this.lapText.text;
		}
		
		public function setPosition(value:int):void{
			position = value;
			this.positionText.text = 'POS: ' + value.toString();
			this.positionTextShadow.text = 'POS: ' + value.toString();
		}
		
		public function setSpeedometerMargins(right:int,bottom:int):void{
			this.speedometerMarginRight=right;
			this.speedometerMarginBottom=bottom;
			setMargins();
		}
		
		public function setSpeedometerMarginBottom(margin:int):void{
			this.speedometerMarginBottom = margin;
			setMargins();
		}
		
		public function setSpeedometerMarginRight(margin:int):void{
			this.speedometerMarginRight = margin;
			setMargins();
		}
		
		public function setSpeedometerHeight(height:int):void{
			var _height:int = h*(height/100);
			var x:Number = _height/this.speedometerOriginalH;
			setSpeedometerDimensions(x);
		}
		
		public function setSpeedometerWidth(width:int):void{
			var _width:int = w*(width/100);
			var x:Number = _width/this.speedometerOriginalW;
			setSpeedometerDimensions(x);
		}
		
		public function setSpeedometerSize(width:int,height:int):void{
			setSpeedometerHeight(height);
			setSpeedometerWidth(width);
		}

		public function setSpeed(value:int):void{
			if( speed < 0 || speed > speedMax )
				return;
			speed = value;
			this.speedText.text = speed.toString();
			this.speedTextShadow.text = speed.toString();
		}
		
	}
}