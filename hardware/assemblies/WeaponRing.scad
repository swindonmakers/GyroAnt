
// tooth connectors
Con_Teeth = [
    [[WeaponOR + 3, 0, ToothScrewSpacing/2], [0,1,0], 30,0,0],
    [[WeaponOR + 3, 0, -ToothScrewSpacing/2], [0,1,0], 30,0,0],
    [[-WeaponOR - 3, 0, ToothScrewSpacing/2], [0,-1,0], 210,0,0],
    [[-WeaponOR - 3, 0, -ToothScrewSpacing/2], [0,-1,0], 210,0,0]
];

module WeaponRingAssembly () {

    assembly("assemblies/WeaponRing.scad", "WeaponRing", str("WeaponRingAssembly()")) {

        // generate an animation video for this assembly
        animation(title="WeaponRing",framesPerStep=10);

        // base part
        WeaponRing_STL();

        // steps
        step(1, "Screw the hammer plates onto the weapon ring") {
            view(t=[0,0,0], r=[52,0,218], d=240);

            for (i=[0:3])
                attach(Con_Teeth[i], DefConDown, ExplodeSpacing = 20)
                translate([0,0,1])  // thickness of plate
                screw(M3_hex_screw, 8);

            // teeth
            for (i=[0,2])
                attach(rollConnector(Con_Teeth[i], -120), HammerPlate_Con_Fixing1)
                HammerPlate();
        }



    }
}
