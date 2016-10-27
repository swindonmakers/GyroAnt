// Connectors

WeaponRing_Con_Def = [[0,0,0], [0,0,-1], 0,0,0];


module WeaponRing_STL() {

    printedPart("printedparts/WeaponRing.scad", "WeaponRing", "WeaponRing_STL()") {

        view(t=[0,0,0],r=[72,0,130],d=400);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
            connector(WeaponRing_Con_Def);
        }

        color(Level4PlasticColor) {
            if (UseSTL) {
                import(str(STLPath, "WeaponRing.stl"));
            } else {
                WeaponRing_Model();
            }
        }
    }
}


module WeaponRing_Model()
{
    // centered on origin
    difference() {
        union() {
            // thin wall
            tube(WeaponOR-RingThickness+0.5, WeaponOR-RingThickness, WheelOD-4);

            // thick rings
            for(i=[0,1])
                mirror([0,0,i])
                translate([0,0, -(WheelOD-2*GroundClearance)/2])
                conicalTube(WeaponOR, WeaponOR-RingThickness, WeaponOR-RingThickness+0.5, WeaponOR-RingThickness, (WheelOD-2*GroundClearance)/3, center=true);

            // v ring
            translate([0,0, - WheelOD/2 + BearingHeight])
            rotate_extrude($fn=200)
                polygon([
                    [WeaponOR-RingThickness-2.3 ,-0.3],
                    [WeaponOR-RingThickness-2.3,0.3],
                    [WeaponOR-RingThickness,2],
                    [WeaponOR-RingThickness,-2]
                ]);

            // 2nd v-ring to rub against outrunner
            translate([0,0, 1])
            rotate_extrude($fn=200)
                polygon([
                    [WeaponOR-RingThickness-2.3 ,-0.3],
                    [WeaponOR-RingThickness-2.3,0.3],
                    [WeaponOR-RingThickness,2],
                    [WeaponOR-RingThickness,-2]
                ]);
        }

        // debug
        *rotate([0,0,45]) translate([0,0,-50]) cube([100,100,100]);
    }



    // teeth mounts
    difference()
    {
        union()
            for (i=[0,1])
            rotate([0,0, 180*i])
            translate([WeaponOR-1,0,-(WheelOD-2*GroundClearance)/2 ])
            linear_extrude(WheelOD - 2*GroundClearance)
            polygon([[0,0], [-4,17], [7,2], [7,0]]);

        // weight loss
        translate([0,0, 0])
            rotate_extrude()
                polygon([[WeaponOR+1 ,0], [WeaponOR + 9,7], [WeaponOR + 9,-7]]);

        // m3 fixings
        for (i=[0,1], j=[-1,1])
            rotate([0,0, 180*i])
            translate([WeaponOR + 3, -1 , j*7])
            rotate([90,0,0])
            cylinder(r=3.2/2, h=30, center=true, $fn=12);
    }

}
