// ============================================================
// tx_base.scad  -  Gesture TX enclosure, BASE
// Rebuilt as editable OpenSCAD from tx_base.stl
// Units: mm. Same coordinates as the STL, so the two overlay exactly.
// Dimensions were measured from cross-sections of the STL (about +/-0.1 mm).
// ============================================================

$fn = 64;

// ---- Overlay the original STL as a ghost, to compare ----
show_original = false;          // true = also draw the original STL (transparent in preview)
original_file = "tx_base.stl";  // keep it next to this .scad file

// ---- Main body ----
box_w    = 99.8;   // outer width  (X)
box_d    = 75.8;   // outer depth  (Y)
box_cy   = 2;      // Y of the box centre (the box is not centred on y=0)
wall     = 3.4;    // wall thickness, lower part
floor_t  = 3;      // floor thickness
body_h   = 12;     // height of the full-thickness wall; the thin lip starts here
total_h  = 22;     // overall height
lip_wall = 1.6;    // thin lip wall thickness (z = body_h .. total_h)
cav_r    = 5.5;    // inner cavity corner radius

// derived values: edit the numbers above instead of these
corner_r = cav_r + wall;        // outer corner radius (8.9)
cav_w    = box_w - 2*wall;      // cavity width (93)
cav_d    = box_d - 2*wall;      // cavity depth (69)
lip_w    = cav_w + 2*lip_wall;  // lip outer width (96.2)
lip_d    = cav_d + 2*lip_wall;  // lip outer depth (72.2)
lip_r    = cav_r + lip_wall;    // lip outer corner radius (7.1)

// ---- Side wings with strap slots (both sides, z = 0 .. wing_t) ----
wing_t     = 4.5;
wing_in_x  = 44;     // where the wing starts (hidden inside the body)
wing_out_x = 61.9;   // outer edge of wing
wing_y0    = -16;
wing_y1    = 20;
wing_r     = 3;      // wing corner radius
slot_x0    = 52.9;   // strap slot (through the wing)
slot_x1    = 58.1;
slot_y0    = -11.5;
slot_y1    = 15.5;
slot_r     = 1;

// ---- Four corner posts with split snap pins ----
post_x      = 41;    // posts at (+/-post_x, +/-post_y)
post_y      = 27;
post_d      = 8;
post_top    = 15;    // post height
post_hole_d = 4.6;   // ring gap around the pin
post_hole_z = 11;    // gap starts at this height
pin_r       = 1.15;  // pin radius (2.3 dia)
pin_slit    = 0.7;   // slit width (splits the pin in X)
pin_slit_z  = 11.5;  // slit starts here
barb_z      = 16.6;  // pin steps out from pin_r to step_r1 here (flat ledge)
// stepped taper above the ledge: radius r1 up to z1, r2 up to z2, r3 up to z3, r4 up to pin_top
step_r1 = 1.65;  step_z1 = 17.4;
step_r2 = 1.5;   step_z2 = 17.7;
step_r3 = 1.3;   step_z3 = 18.0;
step_r4 = 1.1;   pin_top = 18.3;   // pin_top = top of the pin

// ---- PCB / battery corner guides (L rails) ----
guide_x  = 27;     // guided area is X = -guide_x .. +guide_x  (54 wide)
guide_y0 = -16;    // guided area Y range (38 tall)
guide_y1 = 22;
rail_t   = 2;      // rail thickness
rail_len = 10;     // rail length
rail_top = 11;     // rail top height

// ---- Cut-outs in the thin lip ----
notch_x  = [[-29, -13], [13, 29]];  // X ranges of the two notches (on both long walls)
notch_z0 = 12.8;
notch_z1 = 16;
usb_y0   = 13.5;   // opening in the +X lip wall (USB / charge port)
usb_y1   = 27.5;
usb_z0   = 18.4;   // open from here up to the top

// ============================================================
module rrect2d(w, d, r) {
  offset(r = r) square([w - 2*r, d - 2*r], center = true);
}

module wings() {
  for (sx = [-1, 1]) scale([sx, 1, 1])
    translate([(wing_in_x + wing_out_x)/2, (wing_y0 + wing_y1)/2, 0])
      linear_extrude(height = wing_t)
        rrect2d(wing_out_x - wing_in_x, wing_y1 - wing_y0, wing_r);
}

module wing_slots() {
  for (sx = [-1, 1]) scale([sx, 1, 1])
    translate([(slot_x0 + slot_x1)/2, (slot_y0 + slot_y1)/2, -1])
      linear_extrude(height = wing_t + 2)
        rrect2d(slot_x1 - slot_x0, slot_y1 - slot_y0, slot_r);
}

module lip_notches() {
  for (n = notch_x) for (sy = [-1, 1])
    translate([n[0],
               box_cy + (sy > 0 ? cav_d/2 - 0.5 : -(lip_d/2 + 0.5)),
               notch_z0])
      cube([n[1] - n[0], lip_wall + 1, notch_z1 - notch_z0]);
}

module usb_opening() {
  translate([lip_w/2 - lip_wall - 0.5, usb_y0, usb_z0])
    cube([lip_wall + 1, usb_y1 - usb_y0, total_h + 0.1 - usb_z0]);
}

pin_profile = [
  [0,     post_hole_z - 0.1],
  [pin_r, post_hole_z - 0.1],
  [pin_r, barb_z],
  [step_r1, barb_z],
  [step_r1, step_z1],
  [step_r2, step_z1],
  [step_r2, step_z2],
  [step_r3, step_z2],
  [step_r3, step_z3],
  [step_r4, step_z3],
  [step_r4, pin_top],
  [0,       pin_top]
];

module post(x, y) {
  translate([x, y, 0]) {
    difference() {
      translate([0, 0, floor_t - 0.01])
        cylinder(d = post_d, h = post_top - floor_t + 0.01);
      translate([0, 0, post_hole_z])
        cylinder(d = post_hole_d, h = post_top - post_hole_z + 0.1);
    }
    // split snap pin
    difference() {
      rotate_extrude() polygon(pin_profile);
      translate([-pin_slit/2, -5, pin_slit_z]) cube([pin_slit, 10, 20]);
    }
  }
}

module guides() {
  translate([0, 0, floor_t - 0.01])
    linear_extrude(height = rail_top - floor_t + 0.01)
      for (sx = [-1, 1]) scale([sx, 1]) {
        // top corner
        translate([-guide_x - rail_t, guide_y1 - rail_len]) square([rail_t, rail_len]);
        translate([-guide_x, guide_y1]) square([rail_len, rail_t]);
        // bottom corner
        translate([-guide_x - rail_t, guide_y0]) square([rail_t, rail_len]);
        translate([-guide_x, guide_y0 - rail_t]) square([rail_len, rail_t]);
      }
}

// ============================================================
union() {
  difference() {
    union() {
      // lower body
      translate([0, box_cy, 0])
        linear_extrude(height = body_h) rrect2d(box_w, box_d, corner_r);
      // thin lip
      translate([0, box_cy, body_h - 0.01])
        linear_extrude(height = total_h - body_h + 0.01) rrect2d(lip_w, lip_d, lip_r);
      wings();
    }
    // cavity
    translate([0, box_cy, floor_t])
      linear_extrude(height = total_h) rrect2d(cav_w, cav_d, cav_r);
    wing_slots();
    lip_notches();
    usb_opening();
  }
  for (sx = [-1, 1], sy = [-1, 1]) post(sx*post_x, sy*post_y);
  guides();
}

if (show_original) { %import(original_file); }
