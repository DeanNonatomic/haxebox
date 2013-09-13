haxebox
=======

Tools for making gamedev with Haxe and OpenFL even easier.

PhysicsEditor Exporter
======================

In the tools folder you'll find the files you'll need to add as a custom exporter within PhysicsEditor (by @CodeAndWeb). Chuck these whereever you usually keep your custom exporters :)

Then you can use the 'com.haxebox.factory.PhysicsFactory.hx' class to read the exported JSON data and create you a Nape body thusly:

// To load in the exported data, pass in the address to the JSON file to 'loadPhysicsData',  
// but leave out the '.json' extension. You only need to do this once.  
PhysicsFactory.loadPhysicsData("data/ExamplePhysicsData");  

// Then get a new Nape body out of PhysicsFactory class by passing in the body name  
// and position data to 'createPhysicsBody'.  
// Do this for each new body you wish to create.  
var x = 50;  
var y = 50;  
var body = PhysicsFactory.createPhysicsBody("ExampleBox", x, y);  
