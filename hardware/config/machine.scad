//
// Machine
//

// Coding-style
// ------------
//
// Global variables are written in UpperCamelCase.
// A logical hierarchy should be indicated using underscores, for example:
//     StepperMotor_Connections_Axle
//
// Global short-hand references should be kept to a minimum to avoid name-collisions


// Global Settings for Printed Parts
//

DefaultWall 	= 4*perim;
ThickWall 		= 8*perim;

// short-hand
dw 				= DefaultWall;
tw 				= ThickWall;


// Global design parameters
WheelOD = 25;
WeaponOR = 72/2;
RingThickness = 2;
GroundClearance = 2;
BearingAngles = [46, 134, 270];
BearingOffset = WeaponOR-RingThickness-7;
BearingHeight = 8; // from ground plane
ToothScrewSpacing = 14;
