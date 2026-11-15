// motor_bracket_A - editable OpenSCAD rebuild of the STL (mm). Cavity runs full height.
$fn=96;

module part() {
difference() {
union() {
    translate([0,0,0]) cube([24.8,26.2,50]);
}
union() {
    translate([3,2.4,-1]) cube([18.8,22.3,52]);
    translate([21.7,9.65,8]) rotate([0,90,0]) cylinder(r=1.7,h=3.2);
    translate([21.7,9.65,8]) rotate([0,90,0]) cylinder(r=3.1,h=1.8);
    translate([21.7,9.65,42]) rotate([0,90,0]) cylinder(r=1.7,h=3.2);
    translate([21.7,9.65,42]) rotate([0,90,0]) cylinder(r=3.1,h=1.8);
    translate([12.4,24.6,35]) rotate([-90,0,0]) cylinder(r=5.4,h=1.7);
}
}
}

part();
