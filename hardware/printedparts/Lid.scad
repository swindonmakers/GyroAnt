// Connectors

Lid_Con_Def = [[0,0,0], [0,0,-1], 0,0,0];


module Lid_STL() {

    printedPart("printedparts/Lid.scad", "Lid", "Lid_STL()") {

        view(t=[0,0,0],r=[72,0,130],d=400);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
            connector(Lid_Con_Def);
        }

        color(Level3PlasticColor) {
            if (UseSTL) {
                import(str(STLPath, "Lid.stl"));
            } else {
                Lid_Model();
            }
        }
    }
}


module Lid_Model()
{
    difference() {
        union() {
            cylinder(r=WeaponOR-RingThickness-1, h=0.6, center=true);

            // bearing stuff
            for (i=BearingAngles)
                rotate([0,0,i])
                translate([BearingOffset,0,0]) {

                    // stub
                    if (i<180)
                        translate([0,0,-4])
                        cylinder(r=6, h=4);
                }
        }

        // clearance for outrunner shaft
        attach(Con_M3, DefConDown)
            cylinder(r=9/2, h=100, center=true);

        // clearance for wheels
        translate([0,0,GroundClearance-WheelOD]) {
            attach(Con_LW, DefConDown)
                translate([0,0,-1])
                cylinder(r=WheelOD/2+1, h=7);
            attach(Con_RW, DefConDown)
                translate([0,0,-1])
                cylinder(r=WheelOD/2+1, h=7);
        }

        // bearing stuff
        for (i=BearingAngles)
            rotate([0,0,i])
            translate([BearingOffset,0,-3]) {
                // screw clearance - drill this after printing to avoid need for support
                if (i<180)
                    translate([0,0,-10 - 0.6])
                    cylinder(r=4.5/2, h=10);

                // nut clearance
                if (i<180)
                    cylinder(r=5.5, h=10);
            }
    }
}
