// Connectors

Base_Con_Def = [[0,0,0], [0,0,-1], 0,0,0];


module Base_STL() {

    printedPart("printedparts/Base.scad", "Base", "Base_STL()") {

        view(t=[0,0,0],r=[72,0,130],d=400);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
            connector(Base_Con_Def);
        }

        color(Level3PlasticColor) {
            if (UseSTL) {
                import(str(STLPath, "Base.stl"));
            } else {
                Base_Model();
            }
        }
    }
}


module Base_Model()
{
    br = VGrooveBearing_OD(VGrooveBearing_624VV)/2;
    ir = WeaponOR - RingThickness-3.5;
    h = WheelOD-2*GroundClearance-0.6;

    difference() {
        union() {
            // base plate
            cylinder(r=WeaponOR-RingThickness-1, h=0.6, center=false);

            // bearing stuff
            for (i=BearingAngles)
                rotate([0,0,i])
                translate([BearingOffset,0,0]) {
                    // stub
                    cylinder(r1=6, r2=4, h=BearingHeight - GroundClearance-2.7);

                    // cable protection
                    difference() {
                        tube(br +0.5+perim, br + 0.5, i<180 ? h : 12, center=false);

                        rotate([0,0,-70])
                            sector3D(50, 140, 50, center = true);
                    }

                }

            // wiring containment at rear
            for (i=[0,1])
                mirror([i,0,0])
                rotate([0,0,207])
                tubeSector(ir, ir-perim, 50, h, center = false);

            // outer supports for wheels
            for (i=[0,1])
                mirror([i,0,0])
                translate([28,0,0])
                hull() {
                    translate([0,-5,0]) cube([2, 10, 1]);
                    translate([0,0,11])
                        rotate([0,90,0])
                        cylinder(r=3, h=2);
                }

            // inner supports for wheels
            for (i=[0,1])
                mirror([i,0,0])
                translate([18,0,0])
                union() {
                    // big thin wall
                    translate([0.5,-14,0]) cube([0.5, 26, h]);
                    // thicker for axle support
                    translate([0,-3,0]) cube([1, 6, 14]);
                    // join to curved back section
                    translate([0.5,-14,0]) cube([8.6, 0.5, h]);
                }

            // motor retainers
            // front
            difference() {
                translate([-37/2, 10.3, 0])
                    cube([37, 0.5, h]);

                // cable ways
                for (i=[0,1])
                    mirror([i,0,0])
                    translate([14,8,0])
                    cube([5,3.5,10]);
            }

            // back
            difference() {
                translate([-37/2, -10.3-0.5, 0])
                    cube([37, 0.5, 12.6]);

                // cable ways
                for (i=[0,1])
                    mirror([i,0,0])
                    translate([14,-12,0])
                    cube([5,3.5,10]);
            }

            // left/right locating bars
            for (i=[0,1])
                rotate([0,0,i*180])
                translate([14,0,0])
                cube([1,10,4]);


        }

        // clearance for wheels + shafts
        translate([0,0,-GroundClearance]) {
            attach(Con_LW, DefConDown) {
                translate([0,0,-1])
                    cylinder(r=WheelOD/2+1, h=7);
                cylinder(r=2/2, h=50, center=true);
            }

            attach(Con_RW, DefConDown) {
                translate([0,0,-1])
                    cylinder(r=WheelOD/2+1, h=7);
                cylinder(r=2/2, h=50, center=true);
            }
        }

        // clearance for inserting motor shafts
        translate([0,0,-GroundClearance]) {
            attach(Con_RM, N20DCGearMotor_Con_Def)
                translate([-18,-2,0])
                cube([20,4,8]);
            attach(Con_LM, N20DCGearMotor_Con_Def)
                translate([-2,-2,0])
                cube([20,4,8]);
        }

        // outrunner fixings - glue?


        // clearance for outrunner shaft
        attach(Con_M3, DefConDown)
            cylinder(r=5/2, h=10, center=true);

        // clearance and traps for hex head screws
        for (i=BearingAngles)
            rotate([0,0,i])
            translate([BearingOffset,0,-1]) {
                cylinder(r=4/2, h=10);
                cylinder(r=screw_head_radius(M4_hex_screw)+0.3, h=nut_thickness(M4_nut), $fn=6);
            }

    }
}
