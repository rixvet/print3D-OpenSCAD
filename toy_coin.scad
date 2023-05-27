/*
 * Replacement coin for vintage Frisher Price Retro Cash Register
 *
 * URL: https://github.com/rixvet/print3D-OpenSCAD
 * License: CC-BY-SA-4.0 license
 */

// Radius of coin
radius = 19;

// Diameter of wall
wall = 4;

// Height of plate/text
plate = 2;

// Height of coin
height = 14;
 
// Text to print on TOP of coin
top_text = "P";

// Text to print on Bottom of coin
bottom_text = "P";

// Size of text
text_size = 20;

/* [Other options] */
$fn = 64;

// Outer shell
difference() {
cylinder(h=height,r=radius);
translate([0,0,-1]) cylinder(h=height+2,r=radius-wall);
}

// Inner plate
middle = (height-wall)/2;
translate([0, 0, middle]) 
difference() {
    cylinder(h=plate, r=radius);
    rotate([0,0,45]) translate([0,0,-1]) rotate_extrude(angle=90) translate([radius-wall-plate,0,0]) square([plate,radius]);
    rotate([0,0,180+45]) translate([0,0,-1]) rotate_extrude(angle=90) translate([radius-wall-plate,0,0]) square([plate,radius]);
}


// Text decoration
module tttext() {
    linear_extrude(plate) text(text=top_text, size=text_size, halign="center", valign="center", font="monospace");
}
translate([1, 0, middle+plate]) tttext();
translate([-1, 0, middle-plate]) rotate([180,0,180]) tttext();