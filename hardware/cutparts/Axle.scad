/*
    Cutpart: Axle

    Local Frame:
*/


// Connectors

Axle_Con_Def				= [ [0,0,0], [0,0,-1], 0, 0, 0];



module Axle(complete=false) {

    if (DebugCoordinateFrames) frame();
    if (DebugConnectors) {
        connector(Axle_Con_Def);
    }

    cutPart(
        "cutparts/Axle.scad",
        "Axle",
        "Axle()",  // call to use to show a particular step
        "Axle(true)",  // call to use to show final part
        2,   // how many steps
        complete  // show as complete?  i.e. last step!
        ) {

        // Most cut parts use a difference...
        difference() {
            step(1, "Start with rod of 2mm steel or similar") {
                view();

                StockMetal(StockMetal_RoundBar_2, 100, Material_SS);
            }

            step(2, "Cut off a 14mm length") {
                view();

                translate([-5,-5,14])
                    cube([10,10,100]);
            }
        }

    }
}
