package;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Cubic;
import com.eclecticdesignstudio.motion.easing.Elastic;
import com.eclecticdesignstudio.motion.easing.Quad;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.display.Tilesheet;
import nme.events.Event;
import nme.events.EventDispatcher;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.Lib;
import nme.media.Sound;
import nme.text.TextField;
import nme.text.TextFieldType;

typedef Tile = {x: Float, y: Float, s:Float, w:Float, a:Float, r:Float, g:Float, b:Float, rot:Float}


class Simple extends Sprite {
    private var tsheet:Tilesheet;
    private var sound:Sound;
    private var lame:Tile;
    private function new () {
        super();
        tsheet = new Tilesheet (Assets.getBitmapData ("assets/Untitled.png"));

        sound = Assets.getSound ("assets/Explosion.wav");
        sound.play();

        lame = { x:0, y:0, s:0, w:0, a:0, r:0, g:0, b:0, rot:0 };

        for (y in 0...2) {
            for (x in 0...32) {
                tsheet.addTileRect(new Rectangle(x*8, y*8, 7, 7), new Point(0, 0));
            }
        }
        tsheet.addTileRect (new Rectangle(0, 2*8, 7, 7), new Point(0, 0));
        addEventListener (Event.ADDED_TO_STAGE, this_onAddedToStage);
    }

    private function this_onAddedToStage (event:Event):Void {
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        

        stage.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) {
            var temp = {x: event.localX, y: event.localY};
            Actuate.stop(lame);
            Actuate.tween(lame, 1, temp);
            sound.play();
        });

        addEventListener(Event.ENTER_FRAME, this_onEnterFrame);
    }
    private function this_onEnterFrame (?event:Event):Void {
        graphics.clear();
        var tArray:Array<Float> = new Array<Float>();
        var currentArrayIndex:Int = 0;
        var scale:Int = 5;

        for (x in 0...20) {
            for (y in 0...20) {
                tArray[currentArrayIndex    ] = 1 + x*(scale*7 + 1);
                tArray[currentArrayIndex + 1] = 1 + y*(scale*7 + 1);
                tArray[currentArrayIndex + 2] = 64;
                tArray[currentArrayIndex + 3] = scale;
                tArray[currentArrayIndex + 4] = 1;
                tArray[currentArrayIndex + 5] = 1;
                tArray[currentArrayIndex + 6] = 1;
                currentArrayIndex += 7;
            }
        }

        tArray[currentArrayIndex    ] = lame.x;
        tArray[currentArrayIndex + 1] = lame.y;
        tArray[currentArrayIndex + 2] = 16;
        tArray[currentArrayIndex + 3] = 2;
        tArray[currentArrayIndex + 4] = 1;
        tArray[currentArrayIndex + 5] = 1;
        tArray[currentArrayIndex + 6] = 1;
        currentArrayIndex += 7;

        tsheet.drawTiles(graphics, tArray, false, Tilesheet.TILE_SCALE | Tilesheet.TILE_RGB);   
    }
    public static function main () {
        Lib.current.addChild (new Simple());
    }
}