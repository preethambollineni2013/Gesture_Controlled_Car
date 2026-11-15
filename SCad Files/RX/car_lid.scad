// car_lid - editable OpenSCAD rebuild of the STL (mm). Z=0 is the outer lid face.
$fn=96;

module part() {
difference() {
union() {
difference() {
union() {
    hull() for (x=[-100.15,100.15], y=[-52.9,52.9]) translate([x,y,0]) cylinder(r=8,h=20);
}
union() {
    hull() for (x=[-100.15,100.15], y=[-52.9,52.9]) translate([x,y,3]) cylinder(r=5.6,h=18);
}
}
    hull() for (x=[-100.1,100.1], y=[-52.85,52.85]) translate([x,y,20]) cylinder(r=5.4,h=3);
}
union() {
    translate([-103.95,-56.7,20]) cube([207.9,113.4,4]);
    translate([32.1,-61.9,20]) cube([6.8,123.8,4]);
    translate([-20.25,-48.5,-1]) cube([3,37,4.1]);
    translate([-18.75,-48.5,-1]) cylinder(r=1.5,h=4.1);
    translate([-18.75,-11.5,-1]) cylinder(r=1.5,h=4.1);
    translate([-14.25,-48.5,-1]) cube([3,37,4.1]);
    translate([-12.75,-48.5,-1]) cylinder(r=1.5,h=4.1);
    translate([-12.75,-11.5,-1]) cylinder(r=1.5,h=4.1);
    translate([-8.25,-48.5,-1]) cube([3,37,4.1]);
    translate([-6.75,-48.5,-1]) cylinder(r=1.5,h=4.1);
    translate([-6.75,-11.5,-1]) cylinder(r=1.5,h=4.1);
    translate([-2.25,-48.5,-1]) cube([3,37,4.1]);
    translate([-0.75,-48.5,-1]) cylinder(r=1.5,h=4.1);
    translate([-0.75,-11.5,-1]) cylinder(r=1.5,h=4.1);
    translate([3.75,-48.5,-1]) cube([3,37,4.1]);
    translate([5.25,-48.5,-1]) cylinder(r=1.5,h=4.1);
    translate([5.25,-11.5,-1]) cylinder(r=1.5,h=4.1);
    translate([9.75,-48.5,-1]) cube([3,37,4.1]);
    translate([11.25,-48.5,-1]) cylinder(r=1.5,h=4.1);
    translate([11.25,-11.5,-1]) cylinder(r=1.5,h=4.1);
    translate([-93.75,-51,-1]) cylinder(r=1.7,h=4.1);
    translate([-93.75,-51,-1]) cylinder(r=3.2,h=2.6);
    translate([-93.75,51,-1]) cylinder(r=1.7,h=4.1);
    translate([-93.75,51,-1]) cylinder(r=3.2,h=2.6);
    translate([96.25,-51,-1]) cylinder(r=1.7,h=4.1);
    translate([96.25,-51,-1]) cylinder(r=3.2,h=2.6);
    translate([96.25,51,-1]) cylinder(r=1.7,h=4.1);
    translate([96.25,51,-1]) cylinder(r=3.2,h=2.6);
    translate([35.5,-54.8,-1]) cylinder(r=1.7,h=4.1);
    translate([35.5,-54.8,-1]) cylinder(r=3.2,h=2.6);
    translate([35.5,54.8,-1]) cylinder(r=1.7,h=4.1);
    translate([35.5,54.8,-1]) cylinder(r=3.2,h=2.6);
    translate([-109.15,26,11.26]) rotate([0,90,0]) cylinder(r=6.1,h=3.4);
    translate([-109.15,-26,11.3]) rotate([0,90,0]) cylinder(r=5.65,h=3.4);
    translate([-22.5,-61.9,3.8]) cube([13,3.4,12.5]);
    translate([4.5,-61.9,10.4]) cube([13,3.4,7]);
}
}
}

part();
