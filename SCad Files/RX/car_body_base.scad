// car_body_base - editable OpenSCAD rebuild of the STL (mm). Z=0 is the floor underside.
$fn=96;

module part() {
difference() {
union() {
difference() {
union() {
    hull() for (x=[-100.15,100.15], y=[-52.9,52.9]) translate([x,y,0]) cylinder(r=8,h=15.25);
}
union() {
    hull() for (x=[-100.15,100.15], y=[-52.9,52.9]) translate([x,y,3]) cylinder(r=5.6,h=13.25);
}
}
    translate([-64.75,-48,3]) cylinder(r=4.5,h=3);
    translate([-64.75,48,3]) cylinder(r=4.5,h=3);
    translate([-30.75,-48,3]) cylinder(r=4.5,h=3);
    translate([-30.75,48,3]) cylinder(r=4.5,h=3);
    translate([25.25,-48,3]) cylinder(r=4.5,h=3);
    translate([25.25,48,3]) cylinder(r=4.5,h=3);
    translate([59.25,-48,3]) cylinder(r=4.5,h=3);
    translate([59.25,48,3]) cylinder(r=4.5,h=3);
    translate([-93.75,-51,3]) cylinder(r=4,h=28.75);
    translate([-93.75,51,3]) cylinder(r=4,h=28.75);
    translate([96.25,-51,3]) cylinder(r=4,h=28.75);
    translate([96.25,51,3]) cylinder(r=4,h=28.75);
    translate([35.5,-54.8,3]) cylinder(r=4,h=28.75);
    translate([35.5,54.8,3]) cylinder(r=4,h=28.75);
    translate([-25.85,-40.03,3]) cylinder(r=3.5,h=5);
    translate([-25.85,-40.03,8]) cylinder(r=1.45,h=3.6);
    translate([7.17,12.04,3]) cylinder(r=3.5,h=5);
    translate([7.17,12.04,8]) cylinder(r=1.45,h=3.6);
    translate([-20.77,12.04,3]) cylinder(r=3.5,h=5);
    translate([-20.77,12.04,8]) cylinder(r=1.45,h=3.6);
    translate([-5.75,54.5,3]) cylinder(r=3.5,h=5);
    translate([-5.75,54.5,8]) cylinder(r=1.45,h=3.6);
    translate([22.41,-38.76,3]) cylinder(r=3.5,h=5);
    translate([22.41,-38.76,8]) cylinder(r=1.45,h=3.6);
    translate([37.95,32.9,3]) cube([2.4,10,6]);
    translate([37.95,-42.9,3]) cube([2.4,10,6]);
    translate([40.35,42.9,3]) cube([10,2.4,6]);
    translate([40.35,-45.3,3]) cube([10,2.4,6]);
    translate([103.15,32.9,3]) cube([2.4,10,6]);
    translate([103.15,-42.9,3]) cube([2.4,10,6]);
    translate([93.15,42.9,3]) cube([10,2.4,6]);
    translate([93.15,-45.3,3]) cube([10,2.4,6]);
    translate([-87.15,27,3]) cube([2.4,12,8]);
    translate([-87.15,-39,3]) cube([2.4,12,8]);
    translate([-84.75,39,3]) cube([12,2.4,8]);
    translate([-84.75,-41.4,3]) cube([12,2.4,8]);
    translate([-41.75,27,3]) cube([2.4,12,8]);
    translate([-41.75,-39,3]) cube([2.4,12,8]);
    translate([-53.75,39,3]) cube([12,2.4,8]);
    translate([-53.75,-41.4,3]) cube([12,2.4,8]);
    translate([40.75,30.5,3]) cube([12,12,3]);
    translate([40.75,-42.5,3]) cube([12,12,3]);
    translate([90.75,30.5,3]) cube([12,12,3]);
    translate([90.75,-42.5,3]) cube([12,12,3]);
}
union() {
    translate([-64.75,-48,0]) cylinder(r=1.7,h=3.4);
    translate([0,0,3.4]) linear_extrude(height=2.6) polygon([[-61.9,-46.3546],[-64.75,-44.7091],[-67.6,-46.3546],[-67.6,-49.6454],[-64.75,-51.2909],[-61.9,-49.6454]]);
    translate([-64.75,48,0]) cylinder(r=1.7,h=3.4);
    translate([0,0,3.4]) linear_extrude(height=2.6) polygon([[-61.9,49.6454],[-64.75,51.2909],[-67.6,49.6454],[-67.6,46.3546],[-64.75,44.7091],[-61.9,46.3546]]);
    translate([-30.75,-48,0]) cylinder(r=1.7,h=3.4);
    translate([0,0,3.4]) linear_extrude(height=2.6) polygon([[-27.9,-46.3546],[-30.75,-44.7091],[-33.6,-46.3546],[-33.6,-49.6454],[-30.75,-51.2909],[-27.9,-49.6454]]);
    translate([-30.75,48,0]) cylinder(r=1.7,h=3.4);
    translate([0,0,3.4]) linear_extrude(height=2.6) polygon([[-27.9,49.6454],[-30.75,51.2909],[-33.6,49.6454],[-33.6,46.3546],[-30.75,44.7091],[-27.9,46.3546]]);
    translate([25.25,-48,0]) cylinder(r=1.7,h=3.4);
    translate([0,0,3.4]) linear_extrude(height=2.6) polygon([[28.1,-46.3546],[25.25,-44.7091],[22.4,-46.3546],[22.4,-49.6454],[25.25,-51.2909],[28.1,-49.6454]]);
    translate([25.25,48,0]) cylinder(r=1.7,h=3.4);
    translate([0,0,3.4]) linear_extrude(height=2.6) polygon([[28.1,49.6454],[25.25,51.2909],[22.4,49.6454],[22.4,46.3546],[25.25,44.7091],[28.1,46.3546]]);
    translate([59.25,-48,0]) cylinder(r=1.7,h=3.4);
    translate([0,0,3.4]) linear_extrude(height=2.6) polygon([[62.1,-46.3546],[59.25,-44.7091],[56.4,-46.3546],[56.4,-49.6454],[59.25,-51.2909],[62.1,-49.6454]]);
    translate([59.25,48,0]) cylinder(r=1.7,h=3.4);
    translate([0,0,3.4]) linear_extrude(height=2.6) polygon([[62.1,49.6454],[59.25,51.2909],[56.4,49.6454],[56.4,46.3546],[59.25,44.7091],[62.1,46.3546]]);
    translate([-93.75,-51,25.75]) cylinder(r=2.1,h=6);
    translate([-93.75,51,25.75]) cylinder(r=2.1,h=6);
    translate([96.25,-51,25.75]) cylinder(r=2.1,h=6);
    translate([96.25,51,25.75]) cylinder(r=2.1,h=6);
    translate([35.5,-54.8,25.75]) cylinder(r=2.1,h=6);
    translate([35.5,54.8,25.75]) cylinder(r=2.1,h=6);
}
}
}

part();
