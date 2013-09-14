// Haxebox: http://www.haxebox.com
// Nonatomic Ltd.: http://www.nonatomic.co.uk

package com.haxebox.factory;

import nape.phys.Material;
import nape.shape.Circle;
import flash.geom.Point;
import nape.phys.BodyType;
import nape.geom.Vec2;
import nape.shape.Polygon;
import openfl.Assets;
import haxe.Json;
import nape.phys.Body;

class PhysicsFactory {

	private static var bodies:Map<String, BodyData> = new Map<String, BodyData>();

	public static function loadPhysicsData(src:String) {
		var json = Json.parse(Assets.getText(src + ".json"));

		for (bodyName in Reflect.fields(json)) {
			var bodyData = new BodyData(Reflect.field(json, bodyName));
			bodies.set(bodyName, bodyData);
		}
	}

	public static function createPhysicsBody(bodyName:String, x:Float, y:Float):PhysicsBody {
		var physicsBody:PhysicsBody = null;

		if (bodies.exists(bodyName)) {
			var bodyData:BodyData = bodies.get(bodyName);

			var bodyType:BodyType;
			switch (bodyData.bodyType.toLowerCase()) {
				case "dynamic":
					bodyType = BodyType.DYNAMIC;
				case "static":
					bodyType = BodyType.STATIC;
				case "kinematic":
					bodyType = BodyType.KINEMATIC;
				default:
					bodyType = BodyType.DYNAMIC;
			}

			var size = new Point(bodyData.size.x, bodyData.size.y);
			var anchorPoint = new Point(bodyData.anchorPoint.x, bodyData.anchorPoint.y);
			var anchorPointRelative = new Point(bodyData.anchorPointRelative.x, bodyData.anchorPointRelative.y);
			var body = new Body(bodyType, new Vec2(x, y));

			for (fixtureData in bodyData.fixtures) {
				var material = new Material(
					fixtureData.elasticity,
					fixtureData.dynamicFriction,
					fixtureData.staticFriction,
					fixtureData.density,
					fixtureData.rollingFriction
				);

				if (fixtureData.isCircle) {
					var circle = new Circle(
						fixtureData.radius,
						Vec2.weak(fixtureData.center.x, fixtureData.center.y),
						material
					);
					body.shapes.add(circle);
				}
				else {
//					var vertices = new Array<Vec2>();
//					for (point in fixtureData.hull) {
//						vertices.push(Vec2.weak(point.x, point.y));
//					}
//
//					var polygon = new Polygon(vertices);
//					body.shapes.add(polygon);
					for (polygon in fixtureData.polygons) {
						var vertices = new Array<Vec2>();
						for (point in polygon) {
							vertices.push(Vec2.weak(point.x, point.y));
						}
						var polygon = new Polygon(vertices, material);
						body.shapes.add(polygon);
					}
				}
			}

			physicsBody = new PhysicsBody(size, anchorPoint, anchorPointRelative, body);
		}
		else {
			trace("**WARNING** No body data for name: " + bodyName);
		}

		return physicsBody;
	}

}

class PhysicsBody {

	public var size:Point;
	public var anchorPoint:Point;
	public var anchorPointRelative:Point;
	public var body:Body;

	public function new(size:Point, anchorPoint:Point, anchorPointRelative:Point, body:Body) {
		this.size = size;
		this.anchorPoint = anchorPoint;
		this.anchorPointRelative = anchorPointRelative;
		this.body = body;
	}

}

private class BodyData {

	public var size:Point;
	public var anchorPoint:Point;
	public var anchorPointRelative:Point;
	public var bodyType:String;
	public var fixtures:Array<FixtureData>;

	public function new(data:Dynamic) {
		size = new Point(data.size.width, data.size.height);
		anchorPoint = new Point(data.anchorPoint.x, data.anchorPoint.y);
		anchorPointRelative = new Point(data.anchorPointRelative.x, data.anchorPointRelative.y);
		bodyType = data.bodyType;
		fixtures = new Array<FixtureData>();
		for (fixture in cast(data.fixtures, Array<Dynamic>)) {
			var fixtureData = new FixtureData(fixture);
			fixtures.push(fixtureData);
		}
	}

}

private class FixtureData {

	public var isSensor:Bool;
	public var density:Float;
	public var elasticity:Float;
	public var dynamicFriction:Float;
	public var staticFriction:Float;
	public var rollingFriction:Float;
	public var type:String;
	public var isCircle:Bool;

	// Circle specific data
	public var center:Point;
	public var radius:Float;

	// Polygon specific data
	public var hull:Array<Point>;
	public var polygons:Array<Array<Point>>;

	public function new(data:Dynamic) {
		isSensor = data.isSensor;
		density = data.density;
		elasticity = data.elasticity;
		dynamicFriction = data.dynamicFriction;
		staticFriction = data.staticFriction;
		rollingFriction = data.rollingFriction;
		type = data.type;
		isCircle = data.isCircle;

		if (isCircle) {
			center = new Point(data.center.x, data.center.y);
			radius = data.radius;
		}
		else {
			hull = new Array<Point>();
			for (point in cast(data.hull, Array<Dynamic>)) {
				hull.push(new Point(point.x, point.y));
			}

			polygons = new Array<Array<Point>>();
			for (polygon in cast(data.polygons, Array<Dynamic>)) {
				var points = new Array<Point>();
				for (point in cast(polygon.points, Array<Dynamic>)) {
					points.push(new Point(point.x, point.y));
				}
				polygons.push(points);
			}
		}
	}
}
