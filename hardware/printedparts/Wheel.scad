// Connectors

Wheel_Con_Def = [[0,0,0], [0,0,-1], 0,0,0];


module Wheel_STL() {

    printedPart("printedparts/Wheel.scad", "Wheel", "Wheel_STL()") {

        view(t=[0,0,0],r=[72,0,130],d=400);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
            connector(Wheel_Con_Def);
        }

        color(Level4PlasticColor) {
            if (UseSTL) {
                import(str(STLPath, "Wheel.stl"));
            } else {
                Wheel_Model();
            }
        }
    }
}


module Wheel_Model()
{
    difference() {
        union() {
            // tyre
            tube(WheelOD/2, WheelOD/2-2, h=5, center=false);

            // spokes
            for (i=[0:3])
                rotate([0,0,i*360/4 + 45])
                translate([0,-2,0])
                cube([WheelOD/2-1, 4, 1]);

            // hub
            cylinder(r=8/2, h=3);

            // vslot
            translate([0,0,5])
                for(i=[0,1])
                mirror([0,0,i])
                cylinder(r1=3, r2=4, h=2);
        }

        // shaft
        cylinder(r=2/2, h=100, center=true);
    }
}
