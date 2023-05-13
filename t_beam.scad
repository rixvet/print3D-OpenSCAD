/* T-beam with fillet for added strength
 *
 * URL: https://github.com/rixvet/print3D-OpenSCAD
 * License: CC-BY-SA-4.0 license 
 * 
 */

// Thickness of barrier
thickness = 3;

// Length of barrier
length = 170;

// Width of barrier
width = 30;

// Height of barrier
height = 25;

/* [Other] */
$fn = 64;
    
union() {
    translate([0,-thickness/2,0]) cube([length, thickness, height]);
    translate([0, -width/2, thickness]) rotate([-90, 0, 0]) cube([length, thickness, width]);
    translate([0,-thickness/2,thickness]) fillet(length, thickness);
    translate([0,thickness/2,thickness]) rotate([-90,0,0]) fillet(length, thickness);
    translate([0,width/2,0]) rotate([-90,0,0]) fillet(length, thickness);
    translate([0,-width/2]) fillet(length, thickness);

}

module fillet(l, t) {
    translate([0,-t,t])
    rotate([0, 90, 0])
    difference() {
        cube([t,t,l]);
        translate([0,0,-1]) cylinder(h=l*2, r=t);
    }
 }