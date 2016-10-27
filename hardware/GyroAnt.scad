include <config/config.scad>

STLPath = "printedparts/stl/";
VitaminSTL = "vitamins/stl/";

DebugCoordinateFrames = 0;
DebugConnectors = false;

UseSTL = true;

machine("GyroAnt.scad","GyroAnt") {

    view(size=[1024,768], t=[0,0,16], r=[66, 0, 238], d=250);

    //Top level assembly
    FinalAssembly();
}
