// motor_bracket_B - editable OpenSCAD rebuild of the STL (mm). Mirror of A in Y.
$fn=96;

module part() {
difference() {
union() {
    translate([0,-26.2,0]) cube([24.8,26.2,50]);
}
union() {
    translate([3,-24.7,-1]) cube([18.8,22.3,52]);
    translate([21.7,-9.65,8]) rotate([0,90,0]) cylinder(r=1.7,h=3.2);
    translate([21.7,-9.65,8]) rotate([0,90,0]) cylinder(r=3.1,h=1.8);
    translate([21.7,-9.65,42]) rotate([0,90,0]) cylinder(r=1.7,h=3.2);
    translate([21.7,-9.65,42]) rotate([0,90,0]) cylinder(r=3.1,h=1.8);
    translate([12.4,-26.3,35]) rotate([-90,0,0]) cylinder(r=5.4,h=1.7);
}
}
}

part();
