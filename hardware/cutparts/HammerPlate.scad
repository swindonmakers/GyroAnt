/*
    Cutpart: HammerPlate

    Local Frame:
*/


// Connectors

HammerPlate_Con_Def				= [ [0,0,0], [0,0,-1], 0, 0, 0];
HammerPlate_Con_Fixing1         = [ [ToothScrewSpacing/2,0,0], [0,0,-1], 0, 0, 0];


module HammerPlate(complete=false) {

    if (DebugCoordinateFrames) frame();
    if (DebugConnectors) {
        connector(HammerPlate_Con_Fixing1);
    }

    cutPart(
        "cutparts/HammerPlate.scad",
        "HammerPlate",
        "HammerPlate()",  // call to use to show a particular step
        "HammerPlate(true)",  // call to use to show final part
        2,   // how many steps
        complete  // show as complete?  i.e. last step!
        ) {

        // Most cut parts use a difference...
        difference() {
            step(1, "Cut a small piece of 1mm steel plate to size") {
                view();

                color([0.9,0.9,0.9])
                    rotate([90,0,90])
                    translate([0,0,-(WheelOD - 2*GroundClearance)/2])
                    StockMetal(StockMetal_FlatBar_6x1, WheelOD - 2*GroundClearance, Material_SS);
            }

            step(2, "Drill two 3mm dia holes at 14mm spacing") {
                view();

                for (i=[-1,1])
                    translate([i*ToothScrewSpacing/2, 0, 0])
                    cylinder(r=3/2, h=100, center=true);
            }

        }

    }
}
