package;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Cubic;
import com.eclecticdesignstudio.motion.easing.Quad;
import com.eclecticdesignstudio.motion.easing.Elastic;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.display.Tilesheet;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.geom.Rectangle;
import nme.geom.Point;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.Assets;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFieldType;
import nme.events.EventDispatcher;

class Simple extends Sprite {
    private var tsheet:Tilesheet;
    public function new () {
        super();
        tsheet = new Tilesheet (Assets.getBitmapData ("assets/Untitled.png"));

        var sound = Assets.getSound ("assets/Explosion.wav");
        sound.play ();

        for (y in 0...2) {
            for (x in 0...32) {
                tsheet.addTileRect(new Rectangle(x*8, y*8, 7, 7), new Point(0, 0));
            }
        }
        tsheet.addTileRect (new Rectangle(0, 2*8, 7, 7), new Point(0, 0));
        addEventListener (Event.ADDED_TO_STAGE, this_onAddedToStage);
    }

    private function this_onAddedToStage (event:Event):Void {
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

        tsheet.drawTiles(graphics, tArray, false, Tilesheet.TILE_SCALE | Tilesheet.TILE_RGB);   
    }
    public static function main () {
        Lib.current.addChild (new Simple());
    }
}