/* Parametric ID tag
 *
 * URL: https://github.com/rixvet/print3D-OpenSCAD
 * License: CC-BY-SA-4.0 license 
 * 
 */

/* [General Parameters] */

// Name to display
tag = "rixvet";

// Width of badge (-1: auto-tune for Consolas Font)
width = -1; //[-1:1:200]

// Thickness of badge
thickness = 2;

// Margin between letters and edge
margin = 2;

/* [Hook] */
hook_type = "half_circle"; // ["circle", "half_circle", "none"]

// Thickness of hook
hook_thickness = 4; // [0.1:0.1:10]

/* [Font] */
// Font Family (Help->'Font List' has more options)
font_family = "Consolas"; // ["Consolas", "Liberation Sans"]

// Font Style (Help->'Font List' has more options)
font_style = "Bold"; // ["Bold", "Italic", "Bold Italic"]

// Font size
font_size = 20; // [1:1:60]

// Height of relief letters
font_height = 3;

/* [Other] */
$fn = 64;


// Helper to create 3D text with correct font and orientation
module t(t, spacing = 1) {
  rotate([0, 0, 0])
    linear_extrude(height = font_height)
      text(t, font_size,
           spacing=spacing,
           valign="center",
           font = str(font_family, ":style=", font_style),
           $fn = 32);
}

module green() color([157/255,203/255,81/255]) children();


module badge(font_size, width, font_height) {
    difference(){
        hull() {
            translate([(hook_type=="circle") ? -(font_size/2)+margin: 0,0,0]) cylinder(h=thickness, r=(font_size/2) + margin);
            translate([width,0,0]) cylinder(h=thickness, r=(font_size/2) + margin);
        }
        if (hook_type == "half_circle") {
            translate([0,0,-1]) difference() {
                // Half circle
                cylinder(h=thickness*4, r=(font_size/2) + margin - hook_thickness);
                translate([0,-font_size*2,-2]) cube([font_size*4, font_size*4, thickness*8]);
            }
        }
        else if (hook_type == "circle") {
            translate([-(font_size/2)+margin,0,-1]) cylinder(h=thickness*4, r=(font_size/2) + margin - hook_thickness);    
        }
    }
    translate([margin,0,thickness]) green() t(tag);

}

if (width == -1) {
    // Consolas font
    // size 20: space 4, font 12
    // size 10: space 2: font 6
    auto_width = len(tag) * font_size * 0.765;
    echo("Calculated width: ", auto_width);
    badge(font_size, auto_width, font_height);
} else {
    badge(font_size, width, font_height);
}
