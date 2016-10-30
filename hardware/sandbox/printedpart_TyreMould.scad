include <../config/config.scad>
UseSTL=false;
UseVitaminSTL=true;
DebugConnectors=false;
DebugCoordinateFrames=false;
TyreMould_STL();

translate([0,0,1])
Wheel_STL();
