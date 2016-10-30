// Connectors

TyreMould_Con_Def = [[0,0,0], [0,0,-1], 0,0,0];


module TyreMould_STL() {

    printedPart("printedparts/TyreMould.scad", "Tyre Mould", "TyreMould_STL()") {

        view(t=[0,0,0],r=[72,0,130],d=400);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
            connector(TyreMould_Con_Def);
        }

        color("grey") {
            if (UseSTL) {
                import(str(STLPath, "TyreMould.stl"));
            } else {
                TyreMould_Model();
            }
        }
    }
}


module TyreMould_Model()
{
    t =1.5;
    h= 5;
    difference() {
        union() {
            // base
            cylinder(r=WheelOD/2 + dw, h=1, center=false);

            // walls
            cylinder(r=WheelOD/2 + dw, h=h+1, center=false);

        }

        // tyre
        translate([0,0,1])
            cylinder(r=WheelOD/2, h=100, center=false);

        // weight loss
        cylinder(r=WheelOD/2-TyreThickness-t-2, h=100, center=true);

    }

    // locating pins
    intersection() {
        cylinder(r=WheelOD/2-TyreThickness-t-0.3, h=3);

        union()
            for (i=[0:3])
            rotate([0,0,i*360/4])
            translate([WheelOD/2-TyreThickness-3-0.3,-1,0])
            cube([2, 2, 3]);
    }

}
