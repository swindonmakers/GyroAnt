include <../config/config.scad>
UseSTL=false;
UseVitaminSTL=false;
DebugConnectors=true;
DebugCoordinateFrames=true;


//ORing();



c1 = [[0,0,0], [0,0,-1], 0, 1, 6];
c2 = [[10,0,0], [0,0,-1], 0, 1, 12];
ORingOnShafts(section=2, bore=10, c1=c1, c2=c2);
