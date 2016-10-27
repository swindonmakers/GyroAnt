include <../config/config.scad>
include <../vitamins/MicroServo.scad>

DebugConnectors = false;
DebugCoordinateFrames = false;



// base
translate([0,0, GroundClearance])
    Base_STL();


// servo drives
c1 = [[20,5,9.5], [1,0,0], -90,0,0];
attach(c1, MicroServo_Con_Horn)
    MicroServo();
