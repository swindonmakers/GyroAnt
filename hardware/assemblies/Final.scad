
Con_M3 = [[0,WeaponOR-RingThickness-12.5,3], [0,0,-1], 30,0,0];
Con_RM = [[14,5,GroundClearance+0.6+6], [-1,0,0], 0,0,3];
Con_LM = [[-14,-5,GroundClearance+0.6+6], [1,0,0], 0,0,3];

Con_LW = [[-27, 0, WheelOD/2], [-1,0,0], 0,0,6];
Con_RW = [[27,0,WheelOD/2], [1,0,0], 0,0,6];

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
module FinalAssembly_View2() {
    view(t=[0,0,0], r=[10, 0,358], d=250);
}
module FinalAssembly_View3() {
    view(t=[0,0,0], r=[130, 0,358], d=250);
}

module FinalAssembly () {

    assembly("assemblies/Final.scad", "Final", str("FinalAssembly()")) {

        // base
        translate([0,0, GroundClearance])
            Base_STL();

        step(1, "Locate wheels and insert axles") {
            FinalAssembly_DefView();

            // left wheel
            attach(DefConDown, DefConDown, ExplodeSpacing=30)  // dummy attach to ensure correct explode vector
                attach(Con_LW, DefConDown, ExplodeSpacing=30)
                Wheel_STL();

            // axle
            attach(DefConRight, DefConRight, ExplodeSpacing=15)  // dummy attach to ensure correct explode vector
                attach(Con_LW, DefConDown, ExplodeSpacing=30)
                translate([0,0,-4])
                StockMetal(StockMetal_RoundBar_2, 14, Material_SS);



            // right wheel
            attach(DefConDown, DefConDown, ExplodeSpacing=30)  // dummy attach to ensure correct explode vector
                attach(Con_RW, DefConDown, ExplodeSpacing=30)
                Wheel_STL();
            // axle
            attach(DefConLeft, DefConLeft, ExplodeSpacing=15)  // dummy attach to ensure correct explode vector
                attach(Con_RW, DefConDown, ExplodeSpacing=30)
                translate([0,0,-4])
                StockMetal(StockMetal_RoundBar_2, 14, Material_SS);

        }

        step(2, "Fit motors and o-rings") {
            FinalAssembly_DefView();

            // left motor
            attach(DefConDown, DefConDown, ExplodeSpacing=30)  // dummy attach to ensure correct explode vector
            {
                attach(Con_LM, N20DCGearMotor_Con_Def)
                    N20DCGearMotor(ShaftLength=10);

                // left o-ring
                ORingOnShafts(section=2, bore=10, c1=offsetConnector(Con_LM,[-8,0,0]), c2=offsetConnector(Con_LW, [5,0,0]));
            }


            // right motor
            attach(DefConDown, DefConDown, ExplodeSpacing=30)  // dummy attach to ensure correct explode vector
            {
                attach(Con_RM, N20DCGearMotor_Con_Def)
                    N20DCGearMotor(ShaftLength=10);

                // right o-ring
                ORingOnShafts(section=2, bore=10, c1=offsetConnector(Con_RM,[8,0,0]), c2=offsetConnector(Con_RW, [-5,0,0]));
            }

        }

        //weapon outrunner
        step(3, "Fit weapon outrunner") {
            FinalAssembly_DefView();
            attach(Con_M3, DefConDown, ExplodeSpacing=25)
                C2020BrushlessOutrunner();
        }

        // weapon ring
        step(4, "Slide weapon ring over base, along with v bearings") {
            FinalAssembly_DefView();
            translate([0,0,WheelOD/2]) {
                attach(DefConDown, DefConDown, ExplodeSpacing=30) {
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

            for (i=BearingAngles)
                rotate([0,0,i]) {
                    // bearing
                    translate([BearingOffset,0, BearingHeight - 2.5])
                        attach(DefConDown, DefConDown, ExplodeSpacing=30)
                        VGrooveBearing();
                }
        }


        step(5, "Secure bearings for weapon ring") {
            FinalAssembly_View3();

            // bearings, screws, nuts
            for (i=BearingAngles)
                rotate([0,0,i]) {
                    // screw
                    translate([BearingOffset,0, GroundClearance + 2])
                        attach(DefConUp, DefConUp, ExplodeSpacing=30)
                        rotate([180,0,0])
                        screw(M4_hex_screw, i<180 ? 19 : 15);

                    // nut lower
                    translate([BearingOffset,0, GroundClearance + 9])
                        rotate([0,0,30])
                        attach(DefConDown, DefConDown)
                        nut(M4_nut);
                }
        }

        step(6, "Wire up Rx, ESCs and motors") {
            FinalAssembly_View2();

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

        step(7, "Install battery") {
            FinalAssembly_View2();

            // battery
            attach(Con_Bat, DefConDown)
                TurnigyNanoTech120mAh2S25C();
        }

        step(8, "Fit lid") {
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
                        attach(DefConDown, DefConDown, ExplodeSpacing=20)
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
