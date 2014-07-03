/*
	name: 		bumper-box-extension.scad
	author:		Aymeric B.
	date:		02.07.2014
*/


/****** PARAMETERS ****/
$fn = 50;
thickness = 3;
clearance = 0.1;

inner_width = 109;
inner_height = 74;
inner_depth = 10;
inner_corner_radius = 7;
inner_corner_offset = 10;
outer_width = 111;
outer_height = 76;
outer_depth = 11;
outer_corner_radius = 7;
elevation = 40;


/****** MODULES ****/
module RoundingEdge(radius, length) {	
	difference() {
		translate([0, 0, -clearance]) {
			cube([2*radius+clearance, 2*radius+clearance, length+2*clearance]);
		}
		translate([0, 0, -2*clearance]) {
			cylinder(r=radius,h=length+4*clearance);
		}
	}
}

module RoundingInnerEdge(radius, length) {	
	difference() {
		translate([0, 0, -clearance]) {
			cube([10*radius, 10*radius, length]);
		}
		translate([radius, radius, -clearance]) {
			rotate([0, 0, 180]) RoundingEdge(radius, length);
		}
	}
}

module RoundedOuterCube(width, height, depth, radius) {
	difference() {
		cube([width, height, depth]);
		translate([width-radius, height-radius, 0]) {
			RoundingEdge(radius, depth);
		}
		translate([radius, height-radius, 0]) {
			rotate([0, 0, 90]) RoundingEdge(radius, depth);
		}
		translate([radius, radius, 0]) {
			rotate([0, 0, 180]) RoundingEdge(radius, depth);
		}
		translate([width-radius, radius, 0]) {
			rotate([0, 0, 270]) RoundingEdge(radius, depth);
		}
	}
}

module RoundedInnerCube(width, height, depth, radius, offset) {
	echo("Offset=", offset);
	difference() {
		cube([width, height, depth]);
		translate([width-offset, height-offset, 0]) {
			RoundingInnerEdge(radius, depth+2*clearance);
		}
		translate([offset, height-offset, 0]) {
			rotate([0, 0, 90]) RoundingInnerEdge(radius, depth+2*clearance);
		}
		translate([offset, offset, 0]) {
			rotate([0, 0, 180]) RoundingInnerEdge(radius, depth+2*clearance);
		}
		translate([width-offset, offset, 0]) {
			rotate([0, 0, 270]) RoundingInnerEdge(radius, depth+2*clearance);
		}
	}
}

module Draw() {
	difference() {
		union() {
			color("green") {
				RoundedOuterCube(outer_width+2*thickness, outer_height+2*thickness, elevation-inner_depth, outer_corner_radius);
				translate([(outer_width-inner_width+2*thickness)/2, (outer_height-inner_height+2*thickness)/2, elevation-inner_depth]) {
					RoundedInnerCube(inner_width, inner_height, inner_depth, inner_corner_radius, inner_corner_offset);
				}
			}
		}
		union() {
			color("red") {
				translate([thickness, thickness, -clearance]) {
					RoundedOuterCube(outer_width, outer_height, outer_depth+clearance, outer_corner_radius-thickness);
				}
				translate([(outer_width-inner_width+4*thickness)/2, (outer_height-inner_height+4*thickness)/2, outer_depth-clearance]) {
					RoundedInnerCube(inner_width-2*thickness, inner_height-2*thickness, elevation-outer_depth+2*clearance, inner_corner_radius+thickness, inner_corner_offset);
				}
			}
		}
	}
}

/****** RENDERS ****/
Draw();
