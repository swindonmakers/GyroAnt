
module WheelAssembly () {

    assembly("assemblies/Wheel.scad", "Wheel", str("WheelAssembly()")) {

        // generate an animation video for this assembly
        animation(title="Wheel",framesPerStep=10);

        // base part
        Wheel_STL();

        // steps
        CurStep = $ShowStep;
        step(1, "Place wheel hub into the tyre mould") {
            view(t=[0,0,0], r=[52,0,218], d=240);


            if (CurStep<3 || $ShowBOM)
                attach([[0,0,-1], [0,0,1], 0,0,0], DefConUp)
                  TyreMould_STL();
        }

        AnimT = $AnimateExplodeT;
        step(2, "Pour in rubber to overmould the tyre") {
            view(t=[0,0,0], r=[52,0,218], d=240);

            translate([0,0,0])
                scale([1,1,CurStep==2 ? AnimT : 1])
                  Tyre_STL();


        }


        step(3, "Once dry, remove the finished tyre from the mould") {
            view(t=[0,0,0], r=[52,0,218], d=240);

            if (CurStep<4 || $ShowBOM)
                attach([[0,0,-11], [0,0,-1], 0,0,0], DefConDown)
                TyreMould_STL();
        }



    }
}
