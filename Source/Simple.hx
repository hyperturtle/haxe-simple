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
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.Assets;
import nme.Lib;
import nme.media.Sound;
import nme.text.TextField;
import nme.text.TextFieldType;
import nme.events.EventDispatcher;
import haxe.Timer;

typedef Tile = {x: Float, y: Float, s:Float, w:Float, z:Int, a:Float, r:Float, g:Float, b:Float, rot:Float}
typedef Vector = {x: Float, y:Float}

enum Physical {
    Collides;
}

class Entities {
    private var id:Int;
    public var Tiles:IntHash<Tile>;
    public var Locs:IntHash<Vector>;
    public var Velocities:IntHash<Vector>;
    public var Physicals:IntHash<Physical>;

    public function new () {
        id = 0;
        Tiles = new IntHash<Tile>();
        Locs = new IntHash<Vector>();
        Velocities = new IntHash<Vector>();
        Physicals = new IntHash<Physical>();
    }

    public function next():Int {
        id += 1;
        return id;
    }

    public function addPlayer():Int {
        var playerID = next();
        Locs.set(playerID, {x: 0, y: 0});
        Velocities.set(playerID, {x: 0, y: 0});
        Tiles.set(playerID, {x: 0, y: 0, s:2, w: 68, z:0, a:1, r:1, g:1, b:1, rot:0});
        Physicals.set(playerID, Physical.Collides);
        return playerID;
    }

    public function addBumpee():Int {
        var id = next();
        Locs.set(id, {x: 300, y: 0});
        Velocities.set(id, {x: -5, y: 0});
        Tiles.set(id, {x: 0, y: 0, s:2, w: 65, z:0, a:1, r:1, g:1, b:1, rot:0});
        Physicals.set(id, Physical.Collides);
        return id;
    }
}

class Simple extends Sprite {
    
    private var tsheet:Tilesheet;
    private var _:Entities;

    private var sound:Sound;
    private var playerID:Int;
    private var jumping:Bool;
    private var jumpCount:Int;

    public function new () {
        super();
        tsheet = new Tilesheet (Assets.getBitmapData ("assets/Untitled.png"));
        _ = new Entities();
        jumping = false;
        jumpCount = 0;

        sound = Assets.getSound ("assets/Explosion.wav");
        sound.play ();

        for (y in 0...3) {
            for (x in 0...32) {
                tsheet.addTileRect(new Rectangle(x*8, y*8, 7, 7), new Point(3.5, 3.5));
            }
        }
        tsheet.addTileRect (new Rectangle(0, 2*8, 7, 7), new Point(0, 0));
        addEventListener(Event.ADDED_TO_STAGE, this_onAddedToStage);
    }

    private function this_onAddedToStage (event:Event):Void {

        stage.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) {
            var temp = {x: event.localX, y: event.localY};
            sound.play();
        });

        stage.addEventListener(KeyboardEvent.KEY_DOWN, function (event:KeyboardEvent) {
            if (event.charCode == 32) {
                jumping = true;
            } else {

            }
        });

        stage.addEventListener(Event.ENTER_FRAME, this_onEnterFrame);

        drawString(30, 30, 2, "miniman");


        playerID = _.addPlayer();
        _.addBumpee();
    }

    private function drawString(x:Float, y:Float, s:Float, str:String):Void {
        var tstr = str.toUpperCase();
        var id:Int;
        for (i in 0...tstr.length) {
            if (tstr.charCodeAt(i) != 32) {
                id = _.next();
                _.Tiles.set(id, {x: x, y: y, s:0, w:tstr.charCodeAt(i) - 32, z:0, a:1, r:1, g:1, b:1, rot:2});
                Actuate.tween(_.Tiles.get(id), 0.5, {s: s, rot:0}).ease(Elastic.easeOut).delay(i*0.05);
            }
            x += s * 10;
        }
    }
    private function this_onEnterFrame (event:Event):Void {

        if (jumping && jumpCount >= 0 && jumpCount < 1) {
            jumpCount += 1;
            var vel:Vector = _.Velocities.get(playerID);
            vel.y = 12;
        }
        jumping = false;

        if (_.Locs.get(playerID).y == 0 && jumpCount > 0) {
            jumpCount -= 1;
        }

        for (id in _.Velocities.keys()) {
            var vel:Vector = _.Velocities.get(id);
            var loc:Vector = _.Locs.get(id);
            var tile:Tile = _.Tiles.get(id);

            vel.y -= 1;
            loc.x += vel.x;
            loc.y += vel.y;

            if (loc.y < 0) {
                loc.y = 0;
                vel.y = 0;
            }

            tile.x = 50 + loc.x;
            tile.y = 250 - loc.y;
        }

        graphics.clear();
        var tArray:Array<Float> = new Array<Float>();
        var currentArrayIndex:Int = 0;
        
        var p:Tile;
        for (id in _.Tiles.keys()) {
            p = _.Tiles.get(id);
            tArray[currentArrayIndex    ] = p.x;
            tArray[currentArrayIndex + 1] = p.y;
            tArray[currentArrayIndex + 2] = p.w;
            tArray[currentArrayIndex + 3] = p.s;
            tArray[currentArrayIndex + 4] = p.rot;
            tArray[currentArrayIndex + 5] = p.r;
            tArray[currentArrayIndex + 6] = p.g;
            tArray[currentArrayIndex + 7] = p.b;
            tArray[currentArrayIndex + 8] = p.a;
            currentArrayIndex += 9;
        }

        tsheet.drawTiles(graphics, tArray, false, Tilesheet.TILE_SCALE | Tilesheet.TILE_ALPHA | Tilesheet.TILE_RGB | Tilesheet.TILE_ROTATION);
    }
    public static function main () {
        Lib.current.addChild (new Simple());
    }
}