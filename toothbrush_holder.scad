/*
 * Tooth brusher holder, compatible with:
 * - Philips SonicCare (older thicker model and newer slim models)
 * - Oral-B
 *
 * Extra features:
 * - Hole at the bottom for easy cleaning and support (furture) support of chargers.
 * - [optional] mounting plate to glue on wall
 * - Charger placement support within object
 * 
 * URL: https://github.com/rixvet/print3D-OpenSCAD
 * License: CC-BY-SA-4.0 license
 */

// Inner diameter of holes
diameter = 35;

//Amount of holes required
amount = 3;

// Spacing between brushes
spacing = 5;

// Wall thickness
thickness = 3;

// Total height of holder
height = 80;

// Provide back-mounting plate (for gluing to wall)
mounting_plate = false;

/* [Other] */
$fn = 64;

depth = diameter + spacing*2;
width = ((diameter + spacing) * amount) + spacing;

echo("Total width:" ,width);

difference() {
    translate([0, -(depth)/2, 0]) 
        difference() {
            cube([width,depth,height]);
            translate([thickness,-1,thickness*2]) cube([width-(thickness*2),depth*2,height-thickness*3]);
        }
    
    for(i = [0:amount-1]) {
        c = i * (diameter + spacing) + spacing + (diameter/2);
        translate([c,0,thickness/2]) cylinder(h=height*2,d=diameter);
        /* Looks nicer, but is hard to print */
        //translate([(i * depth) + (diameter/2) + spacing *2 ,1]) cylinder(h=(thickness)+0.1,d1=15,d2=diameter);
        translate([c,0,-1]) cylinder(h=height,d=15);
    }

}

if (mounting_plate) {
    translate([0,depth/2,0]) cube([width, thickness, height/2]);
    }