/* Customizable S-hook with fillet or chamfer and hook tuning
 * By: rixvet
 * Url: https://github.com/rixvet/print3D-OpenSCAD
 * 
 * Remixed from
 * ============
 * - https://homehack.nl/openscad-parametric-hook/
 * - https://www.printables.com/model/91734-parametric-hook-with-source-file
 * 
 * Customizable hook with fillet or chamfer
 * By: Eric Buijs
 * version: 1.1
 * Date: 24-September 2022
 * 
 * Changelog
 * v 1.1. Added countersunk option for screw holes
 * 
 * CC BY-SA (explanation of Creative Common licenses: https://creativecommons.org/licenses/)
 * 
 * Customizable hook that can be changed in length (both horizontal and vertical), width, thickness, radius of the edge, type of edge (fillet or chamfer), diameter of the screw holes. 
 * 
 * By choosing the size of the fillet or chamfer make sure that the sum of each fillet (or chamfer) stays well below the width of the hook.
 * 
*/

/* [Type] */
//type of hook
type = "fillet"; //[fillet, chamfer]

//size of the fillet
fillet = 1; // [0.1:0.1:20]

//size of the chamfer
chamfer = 5;

// S-Hook
is_S_hook = true;

/* [General Dimensions] */
//vertical length of middle square part of the hook 
length1 = 90;

//width of hook
width = 60;

radius1 = width/2;

//thickness of the hook
thickness = 15;

/* [Dimensions of (1st) bottom hook]] */
// vertical length of square part of the end hook
vertical_hook = 20;

//horizontal length square part of the hook
horizontal_length = 40;

// radius of the hook (also changes the total length of the hook)
hookRadius = 10; // [0.1:0.1:90]

// Apply rounding top
is_rounded = true;

/* [Dimensions of (2nd) top hook] */
// vertical length of square part of the end hook
vertical_hook2 = 20;

// horizontal length square part of the 2nd hook
horizontal_length2 = 40;

// radius of the hook (also changes the total length of the hook)
hookRadius2 = 10; // [0.1:0.1:90]

// Apply rounding top
is_rounded2 = true;

/* [Screw holes ] */
// diameter of the screw holes [0: no screw holes]
diameter = 6; // [0,5,6,8,10]

// enable countersunk in screw hole
countersunk = false;

// offset from top of vertical length [-1: auto-tune]
screw_offset_top = -1;

// offse from bottom of vertical length [-1: auto-tune]
screw_offset_bottom = -1;


/* [Other] */
//number of fragments
$fn = 30;


// 

/*** MODULES ***/

//cylinderWithRadius creates a c1ylinder (h1, r1) with a radius r2
module cylinderWithFillet(h1,r1,r2) {
    radius = r2;
    diameter = radius * 2;
    minkowski() {
        cylinder(h = h1 - diameter, r = r1 - (radius), center = true, $fn = 100);
        sphere(r = radius);
    }
}

//halfCylinderWithRadius create half a cylinder (h1, r1) with a radius r2
module halfCylinderWithFillet(h1,r1,r2) {
    difference() {
        cylinderWithFillet(h1,r1,r2);
        translate([0,-r1,-0.5*h1])
        cube([r1,2*r1,h1]);
    }
}

//the fillet module creates a fillet with a length of l and a radius of r1
module fillet(l,r1) {
    intersection() {
        cube([l,l,l]);
        cylinder(h=l, r=r1, $fn=50);
    }
}

// roundedCube creates a cube (l: length of the fillet, w: width, h: thickness) with a radius of r1;
module roundedCube(l,w,h,r1) {
    d = 2 * r1;
    translate([r1,r1,0])
    hull() {
        rotate([0,0,180]) fillet(l,r1);
        translate([0,w-d,0]) rotate([0,0,90]) fillet(l,r1);
        translate([h-d,0,0]) rotate([0,0,270]) fillet(l,r1);
        translate([h-d,w-d,0]) rotate([0,0,0]) fillet(l,r1);
    }
}

// bendedCubeWithFillet creates a bended cube (length, width, thickness) with a fillet size a. hr is the radius of the hook.
module bendedCubeWithFillet(l, w, h, hr) {
    rotate_extrude(angle = 90, convexity = 2, $fn = 50) {
        translate([hr,0,0]) //x-value changes radius
        minkowski() {
            projection()
            roundedCube(l,w,h,fillet);
        }
    }
}

//chamferedCube create a cube (l#translate([thickness/2,width/2,0]) rotate([0,90,0]) cylinder(r=diameter/2, h=thickness+4, center=true);,w,h) with a chamfer (or bevel)
module chamferedCube(l,w,h,c) {
    linear_extrude(height=l) {
        hull() { 
            polygon([[c,0],[0,c],[c,c]]);
            translate([w-c,h-c,0]) polygon([[0,0],[c,0],[0,c]]);
            translate([w-c,0,0]) polygon([[0,0],[0,c],[c,c]]);
            translate([0,h-c,0]) polygon([[0,0],[c,0],[c,c]]);
        }
    }
}

//bendedChamferedCube creates a cube (l,w,h) with a chamfer c. If radius changes also change in MAIN
module bendedChamferedCube(l,w,h,c,hr) {
    rotate_extrude(angle = 90, convexity = 2, $fn = 100)
    translate([hr,0,0]) //x-value changes radius
    projection()
    chamferedCube(l,w,h,c);
}

//halfCylinderWithChamfer create half a circle with radius r and thickness th. It also has a chamfer with size c.
module halfCylinderWithChamfer(r,c,th) {
    rotate_extrude(angle=180,convexity = 2, $fn = 60)
    polygon([[0,0],[r-c,0],[r,c],[r,th-c],[r-c,th],[0,th]]);
}

// added countersunk option in this module
module screwHoles(dia, countersunk) {
    so_top = (screw_offset_top == -1) ? ((is_S_hook) ? length1-radius1/2 : length1) : length1-screw_offset_top;
    so_bottom = (screw_offset_bottom == -1) ? vertical_hook+((is_rounded) ? (width/2) : 0)+diameter: screw_offset_bottom;

    translate([thickness/2,width/2,so_top]) rotate([0,90,0]) cylinder(r=dia/2, h=thickness+4, center=true);
    translate([thickness/2,width/2,so_bottom]) rotate([0,90,0]) cylinder(r=dia/2, h=thickness+4, center=true);
    
    if (countersunk==true) {
   
        translate([thickness/8-0.01,width/2,so_top]) rotate([0,90,0])
        cylinder(r1=dia/2*1.7, r2=dia/2, h=thickness/4, center=true);
        
        translate([thickness/8-0.01,width/2,so_bottom]) rotate([0,90,0])
        cylinder(r1=dia/2*1.7, r2=dia/2, h=thickness/4, center=true);
    }
}

//MAIN
if (type == "fillet") {

    difference() {
        union() {
            roundedCube(length1,width,thickness,fillet);
            translate([-hookRadius,0,0]) rotate([-90,0,0]) bendedCubeWithFillet(length1, width, thickness, hookRadius);
            translate([-horizontal_length-hookRadius,0,-hookRadius]) rotate([0,90,0]) roundedCube(horizontal_length,width,thickness,fillet);
            translate([-horizontal_length-hookRadius,0,0]) rotate([-90,90,0]) bendedCubeWithFillet(length1, width, thickness, hookRadius);
            translate([-horizontal_length-hookRadius-hookRadius-thickness,0,0]) roundedCube(vertical_hook,width,thickness,fillet);
            if (is_rounded) {
                translate([-horizontal_length-(2*hookRadius)-thickness/2,radius1,vertical_hook]) rotate([0,90,0]) halfCylinderWithFillet(thickness,radius1,fillet);
            };
            if (is_S_hook) {
                translate([hookRadius2+thickness,width, length1]) rotate([180,-90,-90]) bendedCubeWithFillet(length1, width, thickness, hookRadius2);
                translate([thickness+hookRadius2,0,length1+hookRadius2+thickness]) rotate([0,90,0]) roundedCube(horizontal_length2,width,thickness,fillet);
                translate([thickness+hookRadius2+horizontal_length2,0,length1]) rotate([0,-90,-90]) bendedCubeWithFillet(length1, width, thickness, hookRadius2);
                translate([thickness+(hookRadius2*2)+horizontal_length2,0,length1-vertical_hook2]) roundedCube(vertical_hook2,width,thickness,fillet);
                if (is_rounded2) {
                    translate([thickness+(2*hookRadius2)+horizontal_length2+(thickness/2),radius1,length1-vertical_hook2]) rotate([0,-90,0]) halfCylinderWithFillet(thickness,radius1,fillet);
                };
            } else {
                translate([thickness/2,radius1,length1]) rotate([0,90,0]) halfCylinderWithFillet(thickness,radius1,fillet);     
            }
        }
        screwHoles(diameter,countersunk);
    }


    echo("The total height of the hook is: ",length1 + hookRadius + thickness + radius1);
    echo("The total depth of the hook is: ",horizontal_length + 2 * (hookRadius + thickness));
    
}

else if (type == "chamfer") {
    difference() {
        translate([thickness,0,0]) rotate([0,0,90])    
        union() {
            chamferedCube(length1,width,thickness,chamfer);
            translate([radius1,thickness,length1]) rotate([90,0,0]) halfCylinderWithChamfer(radius1,chamfer,thickness);
            translate([0,thickness+hookRadius,0]) rotate([-90,0,-90]) bendedChamferedCube(width,thickness,width,chamfer,hookRadius);
            translate([0,thickness+hookRadius,-hookRadius]) rotate([-90,0,0]) chamferedCube(horizontal_length,width,thickness,chamfer);
            translate([0,horizontal_length+thickness+hookRadius,0]) rotate([0,90,0]) bendedChamferedCube(width,thickness,width,chamfer,hookRadius);
            translate([radius1,horizontal_length+2*thickness+2*hookRadius,0]) rotate([90,0,0]) halfCylinderWithChamfer(radius1,chamfer,thickness);
            
            }
            screwHoles(diameter,countersunk);
        }
    
    echo("The total height of the hook is: ",length1 + hookRadius + thickness + radius1);
    echo("The total depth of the hook is: ",length2 + 2 * (hookRadius + thickness));
    
}





