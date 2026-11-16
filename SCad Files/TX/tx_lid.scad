// ============================================================
// tx_lid.scad  -  Gesture TX enclosure, LID
// Rebuilt as editable OpenSCAD from tx_lid.stl
// Units: mm. Same coordinates as the STL, so the two overlay exactly.
// Dimensions were measured from cross-sections of the STL (about +/-0.1 mm).
// ============================================================

$fn = 64;

// ---- Overlay the original STL as a ghost, to compare ----
show_original = false;         // true = also draw the original STL (transparent in preview)
original_file = "tx_lid.stl";  // keep it next to this .scad file

// ---- Main shell ----
box_w   = 99.8;   // outer width  (X)
box_d   = 75.8;   // outer depth  (Y)
box_cy  = 2;      // Y of the box centre (not y=0)
corner_r = 8.9;   // outer corner radius
plate_t = 3;      // top plate thickness (z = 0 .. plate_t)
wall_t  = 1.6;    // side wall thickness
total_h = 23;     // overall height

// derived: edit the numbers above instead
in_w = box_w - 2*wall_t;   // inner width (96.6)
in_d = box_d - 2*wall_t;   // inner depth (72.6)
in_r = corner_r - wall_t;  // inner corner radius (7.3)

// ---- Holes in the top plate ----
sw_cx = -5.5;  sw_cy = 20;     // switch window centre
sw_w  = 12;    sw_d  = 7;      // switch window size
sw_r  = 1;                     // switch window corner radius
led_d = 3.4;                   // LED hole diameter
led_pos = [[-30, -14], [-30, -6.6]];  // LED hole centres

// ---- Openings in the side walls ----
// -X wall
left_y0 = -16.8;  left_y1 = -3.8;  left_z0 = 3.3;  left_z1 = 10.6;
// +X wall
right_y0 = 14;    right_y1 = 27;   right_z0 = 8.6; right_z1 = 16.6;
// top-edge notches (open to the top of the wall)
topL_y0 = 9;      topL_y1 = 23;    // -X wall
topR_y0 = -19;    topR_y1 = -5;    // +X wall
top_z0  = 20.6;

// ---- Snap tabs on the long (+/-Y) walls ----
slit_x = [-29, -14, 13, 28];  // X of each 1 mm slit (left edge)
slit_w = 1;
slit_z0 = 11;                 // slits run from here to the top

bump_x   = [[-27, -15], [15, 27]];  // X range of each latch bump (1 mm inside each tab edge)
// the bump is a 3-step staircase (up and down), heights measured inward from the wall
bump_h1 = 0.3;   // first / last step
bump_h2 = 0.55;  // second / fourth step
bump_h3 = 0.8;   // top step
bump_za = 19.2;  // z where each step starts/ends:
bump_zb = 19.6;
bump_zc = 20.0;
bump_zd = 21.2;
bump_ze = 21.6;
bump_zf = 22.0;

// ============================================================
module rrect2d(w, d, r) {
  offset(r = r) square([w - 2*r, d - 2*r], center = true);
}

module top_holes() {
  translate([sw_cx, sw_cy, -1])
    linear_extrude(height = plate_t + 2) rrect2d(sw_w, sw_d, sw_r);
  for (p = led_pos)
    translate([p[0], p[1], -1]) cylinder(d = led_d, h = plate_t + 2);
}

// wall opening on the -X (side=-1) or +X (side=+1) wall
module x_wall_cut(side, y0, y1, z0, z1) {
  translate([side > 0 ? in_w/2 - 0.5 : -box_w/2 - 0.5, y0, z0])
    cube([wall_t + 1, y1 - y0, z1 - z0]);
}

module y_slits() {
  for (x0 = slit_x) for (sy = [-1, 1])
    translate([x0,
               box_cy + (sy > 0 ? in_d/2 - 0.5 : -(box_d/2 + 0.5)),
               slit_z0])
      cube([slit_w, wall_t + 1, total_h + 0.1 - slit_z0]);
}

// latch bump on the inside of a +/-Y wall tab
module bump(x0, x1, sy) {
  yin = in_d/2;  // inner wall face, relative to box_cy
  translate([x0, box_cy, 0]) scale([1, sy, 1])
    rotate([90, 0, 90])
      linear_extrude(height = x1 - x0)
        polygon([
          [yin + 0.2,      bump_za],
          [yin - bump_h1,  bump_za],
          [yin - bump_h1,  bump_zb],
          [yin - bump_h2,  bump_zb],
          [yin - bump_h2,  bump_zc],
          [yin - bump_h3,  bump_zc],
          [yin - bump_h3,  bump_zd],
          [yin - bump_h2,  bump_zd],
          [yin - bump_h2,  bump_ze],
          [yin - bump_h1,  bump_ze],
          [yin - bump_h1,  bump_zf],
          [yin + 0.2,      bump_zf]
        ]);
}

// ============================================================
union() {
  difference() {
    union() {
      // top plate
      translate([0, box_cy, 0])
        linear_extrude(height = plate_t) rrect2d(box_w, box_d, corner_r);
      // side walls
      difference() {
        translate([0, box_cy, plate_t - 0.01])
          linear_extrude(height = total_h - plate_t + 0.01) rrect2d(box_w, box_d, corner_r);
        translate([0, box_cy, plate_t - 0.02])
          linear_extrude(height = total_h) rrect2d(in_w, in_d, in_r);
      }
    }
    top_holes();
    x_wall_cut(-1, left_y0,  left_y1,  left_z0,  left_z1);
    x_wall_cut( 1, right_y0, right_y1, right_z0, right_z1);
    x_wall_cut(-1, topL_y0,  topL_y1,  top_z0,   total_h + 0.1);
    x_wall_cut( 1, topR_y0,  topR_y1,  top_z0,   total_h + 0.1);
    y_slits();
  }
  for (b = bump_x) for (sy = [-1, 1]) bump(b[0], b[1], sy);
}

if (show_original) { %import(original_file); }
