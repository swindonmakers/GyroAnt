// Connectors

Tyre_Con_Def = [[0,0,0], [0,0,-1], 0,0,0];


module Tyre_STL() {

    printedPart("printedparts/Tyre.scad", "Tyre", "Tyre_STL()") {

        view(t=[0,0,0],r=[72,0,130],d=400);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
            connector(Tyre_Con_Def);
        }

        color(Level3PlasticColor) {
            if (UseSTL) {
                import(str(STLPath, "Tyre.stl"));
            } else {
                Tyre_Model();
            }
        }
    }
}


module Tyre_Model()
{
    t =1.5;
    h= 5;
    difference() {
        union() {
            // tyre
            tube(WheelOD/2, WheelOD/2-TyreThickness, h=h, center=false);

        }

        // keys to hub
        nk = 12;
        for (i=[0:nk-1])
            rotate([0,0,i*360/nk])
            translate([WheelOD/2-TyreThickness-1,-1,-1])
            cube([TyreThickness, 2, h+2]);

    }
}
