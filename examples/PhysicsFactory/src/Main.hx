// Haxebox: http://www.haxebox.com
// Nonatomic Ltd.: http://www.nonatomic.co.uk

// So as not to over-complicate the example of how to use PhysicsFactory 
// there are no bitmaps implemented in this example

package;

import com.haxebox.factory.PhysicsFactory;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.Lib;
import nape.util.Debug;
import nape.util.ShapeDebug;
import nape.space.Space;
import nape.geom.Vec2;

class Main extends Sprite {

	private var space:Space;
	private var debugDraw:Debug;
	private var timer:Timer;

	public function new() {
		super();

		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(e:Event) {
		removeEventListener(Event.ADDED_TO_STAGE, init);

		space = new Space(new Vec2(0, 250));
		debugDraw = new ShapeDebug(1024, 768, 0xffffff);
		addChild(debugDraw.display);

		PhysicsFactory.loadPhysicsData("assets/PhysicsData");

		var x = 512;
		var y = 720;
		var floorBody = PhysicsFactory.createPhysicsBody("Floor", x, y).body;
		floorBody.space = space;

		timer = new Timer(1000);
		timer.addEventListener(TimerEvent.TIMER, onTimerTick);
		timer.start();

		addEventListener(Event.ENTER_FRAME, update);
	}

	private function update(e:Event) {
		debugDraw.clear();
		space.step(0.0333333, 10, 10);
		debugDraw.draw(space);
		debugDraw.flush();
	}

	public function randomBetween(low:Float, high:Float):Float {
		return (Math.random() * (1 + high - low)) + low;
	}

	private function onTimerTick(e:TimerEvent) {
		var randX = randomBetween(100, 924);
		var body = PhysicsFactory.createPhysicsBody("Bike", randX, -100).body;
		body.space = space;
	}

	public static function main():Void {
		Lib.current.addChild(new Main());
	}

}