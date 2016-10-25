
Con_M3 = [[0,WeaponOR-RingThickness-12.5,3], [0,0,-1], 30,0,0];
Con_RM = [[14,5,GroundClearance+0.6+6], [-1,0,0], 0,0,0];
Con_LM = [[-14,-5,GroundClearance+0.6+6], [1,0,0], 0,0,0];

Con_LW = [[-27, 0, WheelOD/2], [-1,0,0], 0,0,0];
Con_RW = [[27,0,WheelOD/2], [1,0,0], 0,0,0];

Con_Rx = [[-22.5/2, -16, 3], [0,0,-1],0,0];
Con_WeaponESC = [[-27/2,-3,15], [0,0,-1], 0,0];

Con_LeftESC = [[-20,-21,3], [0,0,-1], 30,0];
Con_RightESC = [[11,-26,3], [0,0,-1], -30,0];

Con_Bat = [[-33/2, -25, 14.5], [0,0,-1], 0,0];

Con_Lid = [[0,0,WheelOD - GroundClearance - 0.6], [0,0,-1],0,0];

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

module FinalAssembly_DefView() {
    view(t=[0,0,16], r=[66, 0, 238], d=250);
}

module FinalAssembly () {

    assembly("assemblies/Final.scad", "Final", str("FinalAssembly()")) {

        // base
        translate([0,0, GroundClearance])
            Base_STL();

        step(1, "Fit wheels and motors") {
            FinalAssembly_DefView();

            // left motor and wheel
            attach(Con_LM, N20DCGearMotor_Con_Def)
                N20DCGearMotor(ShaftLength=10);
            attach(Con_LW, DefConDown) {
                Wheel_STL();
                // axle
                color("silver")
                    translate([0,0,-4])
                    cylinder(r=2/2, h=14);
            }


            // right motor and wheel
            attach(Con_RM, N20DCGearMotor_Con_Def)
                N20DCGearMotor(ShaftLength=10);
            attach(Con_RW, DefConDown){
                Wheel_STL();
                // axle
                color("silver")
                    translate([0,0,-4])
                    cylinder(r=2/2, h=14);
            }
        }

        //weapon outrunner
        step(2, "Fit weapon outrunner") {
            FinalAssembly_DefView();
            attach(Con_M3, DefConDown)
                C2020BrushlessOutrunner();
        }

        // weapon ring
        step(3, "Slide weapon ring over base") {
            FinalAssembly_DefView();
            translate([0,0,WheelOD/2]) {
                WeaponRing_STL();

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
        }


        step(4, "Fit bearings for weapon ring") {
            FinalAssembly_DefView();

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
                }
        }

        step(5, "Wire up Rx, ESCs and motors") {
            FinalAssembly_DefView();

            // rx
            attach(Con_Rx, DefConDown)
                DasMikroReceiver();

            // brushless esc
            attach(Con_WeaponESC, DefConDown)
                DYS16AESC();

            // brushed ESCs - from Towerpro
            attach(Con_LeftESC, DefConDown)
                TowerProSG90Driver();
            attach(Con_RightESC, DefConDown)
                TowerProSG90Driver();
        }

        step(6, "Install battery") {
            FinalAssembly_DefView();

            // battery
            attach(Con_Bat, DefConDown)
                TurnigyNanoTech120mAh2S25C();
        }

        step(7, "Fit lid") {
            FinalAssembly_DefView();

            // lid
            attach(Con_Lid, DefConDown)
                Lid_STL();

            // bearings, screws, nuts
            for (i=BearingAngles)
                rotate([0,0,i]) {
                    // nut upper
                    if (i<180)
                        translate([BearingOffset,0, WheelOD-5])
                        rotate([0,0,30])
                        nut(M4_nut);
                }
        }



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

    }
}
