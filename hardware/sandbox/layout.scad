include <../config/config.scad>

DebugConnectors = false;
DebugCoordinateFrames = false;

WheelOD = 25;
WeaponOR = 72/2;
RingThickness = 2;
GroundClearance = 2;
BearingAngles = [46, 134, 270];
BearingOffset = WeaponOR-RingThickness-7;
BearingHeight = 8; // from ground plane

Con_M3 = [[0,WeaponOR-RingThickness-12.5,3], [0,0,-1], 30,0,0];
/*
Con_RM = [[12,5,WheelOD/2-5], [-1,0,0], 90,0,0];
Con_LM = [[-12,5,WheelOD/2+5], [1,0,0], 90,0,0];
*/
Con_RM = [[14,5,GroundClearance+0.6+6], [-1,0,0], 0,0,0];
Con_LM = [[-14,-5,GroundClearance+0.6+6], [1,0,0], 0,0,0];

Con_LW = [[-27, 0, WheelOD/2], [-1,0,0], 0,0,0];
Con_RW = [[27,0,WheelOD/2], [1,0,0], 0,0,0];

module Wheel() {
    color("grey") {
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


}

module LeftWheelAssembly() {
    attach([[-2,5,-5], [-1,0,0], 90,0,0], N20DCGearMotor_Con_Def)
        N20DCGearMotor(ShaftLength=10);
}

module Outrunner() {
    color("orange") {
        // base plate - triangular ish thing
        union() {
            cylinder(r=20.2/2, h=2);

            // grind off one of the feet
            for (i=[0:1])
                rotate([0,0,i*120 + 60])
                hull() {
                    cylinder(r=2, h=2);
                    translate([11,0,0])
                        cylinder(r=3, h=2);
                }
        }


        // midriff
        hull() {
            translate([0,0,5.5]) cylinder(r=20.2/2, h=6);

            cylinder(r=20.2/2-5, h=14);
        }

        // prop holder - grind off?
        translate([0,0,14])
            cylinder(r=8/2, h=5);

        // lower circlip
        translate([0,0,-2])
            cylinder(r=3/2, h=2);
    }

    color("grey") {
        //shaft - grind shorter
        translate([0,0,-2.5])
            cylinder(r=2/2, h=23);
    }

    color("black") {
        // wires
        translate([7,-3/2,2])
            cube([8,3,1.5]);
    }
}

module WeaponRing() {
    // centered on origin

    color("grey") {
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
                rotate([0,0, 45 + 180*i])
                translate([WeaponOR-1,0,-(WheelOD-2*GroundClearance)/2 ])
                linear_extrude(WheelOD - 2*GroundClearance)
                polygon([[0,0], [-4,17], [7,2], [7,0]]);

            // weight loss
            translate([0,0, 0])
                rotate_extrude()
                    polygon([[WeaponOR+1 ,0], [WeaponOR + 9,7], [WeaponOR + 9,-7]]);

            // m3 fixings
            for (i=[0,1], j=[-1,1])
                rotate([0,0, 45 + 180*i])
                translate([WeaponOR + 3, -1 , j*7])
                rotate([90,0,0])
                cylinder(r=3.2/2, h=30, center=true, $fn=12);
        }
    }
}

module Base() {
    br = VGrooveBearing_OD(VGrooveBearing_624VV)/2;
    ir = WeaponOR - RingThickness-3.5;
    h = WheelOD-2*GroundClearance-0.6;
    color(Level2PlasticColor) {
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

}

module lid() {
    color(Level3PlasticColor)
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

                        // cable protection
                        *difference() {
                            tube(br +0.5+perim, br + 0.5, i<180 ? h : 12, center=false);

                            rotate([0,0,-70])
                                sector3D(50, 140, 50, center = true);
                        }

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
                    // screw clearance
                    if (i<180)
                        cylinder(r=4.5/2, h=100, center=true);

                    // nut clearance
                    if (i<180)
                        cylinder(r=5.5, h=10);
                }
        }
}


module MainAssembly() {
    attach(Con_RM, N20DCGearMotor_Con_Def)
        N20DCGearMotor(ShaftLength=10);
    attach(Con_LW, DefConDown) {
        Wheel();
        // axle
        color("silver")
            translate([0,0,-4])
            cylinder(r=2/2, h=14);
    }


    attach(Con_LM, N20DCGearMotor_Con_Def)
        N20DCGearMotor(ShaftLength=10);
    attach(Con_RW, DefConDown){
        Wheel();
        // axle
        color("silver")
            translate([0,0,-4])
            cylinder(r=2/2, h=14);
    }

    //weapon outrunner
    attach(Con_M3, DefConDown)
        Outrunner();

    // weapon ring
    translate([0,0,WheelOD/2]) {
        WeaponRing();

        // teeth
        for (i=[0,1])
            rotate([0,0,i*180 + 45]) {
                translate([WeaponOR,-1 , -(WheelOD - 2*GroundClearance)/2])
                    color([0.9,0.9,0.9,1])
                    cube([6, 1, (WheelOD - 2*GroundClearance)]);

                for (j=[-1,1])
                    translate([WeaponOR + 3, -1 , j*7])
                    rotate([90,0,0])
                    rotate([0,0,30])
                    screw(M3_hex_screw, 8);
            }
    }


    // bearings, screws, nuts
    for (i=BearingAngles)
        rotate([0,0,i]) {
            // bearing
            translate([BearingOffset,0, BearingHeight - 2.5])
                VGrooveBearing();

            // screw
            translate([BearingOffset,0, GroundClearance + 2])
                rotate([180,0,0])
                screw(M4_hex_screw, i<180 ? 19 : 15);

            // nut lower
            translate([BearingOffset,0, GroundClearance + 9])
                rotate([0,0,30])
                nut(M4_nut);

            // nut upper
            if (i<180)
                translate([BearingOffset,0, WheelOD-5])
                rotate([0,0,30])
                nut(M4_nut);
        }





    // rx
    translate([-22.5/2, -16, 3])
        color("blue")
        cube([22.5, 3, 10.5]);

    // brushless esc
    translate([-27/2,-3,15])
        color("red")
        cube([27,12,5]);

    // brushed ESCs - from Towerpro
    for (i=[-1,1])
        rotate([0,0,i*40])
        translate([-5,-29,3])
        color("red")
        cube([10,3,10]);


    // wire from left ESC to right motor
    *ribbonCable(
        cables=2,
        cableRadius = 0.6,
        cableSpacing = 2.54,
        points= [
            [-28, 3, 15],
            [-27,30,24],
            [-14,8,15],
            [-14,7, 9]
        ],
        vectors = [
            [0,1,0],
            [0,0,-1],
            [0,0,-1],
            [0,1,0]
        ],
        colors = ["red","blue"]
    );

    // base
    translate([0,0, GroundClearance])
        Base();

    // battery
    translate([-33/2, -25, 14.5]) {
        color("green", 0.5)
            roundedRect([33,20, 7.5],2);
        // cables
        color("black")
            translate([33,2,2])
            rotate([0,0,30])
            cube([8,2,5]);
    }


    // lid
    translate([0,0,WheelOD - GroundClearance - 0.6])
        lid();


/*
Weights:

Electronics
-----------
Outrunner       11g
Brushless ESC   3g
Brushed ESCs    5g
2s battery      8.5g
Gear Motors     2x6g = 12g
Rx              6g
------------
Sub-total       46g

*/

}

*MainAssembly();

*Base();

WeaponRing();

*Outrunner();

// sizing guide
*translate([0,0,-1])
    color("white") cube([100,100,2], center=true);
