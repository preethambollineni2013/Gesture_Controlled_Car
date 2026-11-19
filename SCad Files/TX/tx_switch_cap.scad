$fn = 48;

show_original = false;                
original_file = "tx_switch_cap.stl";  

// ---- Flange (sits against the inside of the lid) ----
flange_w = 14;     // X
flange_d = 8;      // Y
flange_t = 1.2;    // thickness
flange_r = 1.5;    // corner radius

// ---- Stem (passes through the lid switch window) ----
stem_w = 8;        // X
stem_d = 4.4;      // Y
total_h = 15.2;    // overall height

// ---- Socket in the top of the stem (fits over the switch button) ----
sock_w = 6;        // X
sock_d = 3.6;      // Y
sock_z = 12.2;     // socket floor height; open above this

// ============================================================
module rrect2d(w, d, r) {
  offset(r = r) square([w - 2*r, d - 2*r], center = true);
}

difference() {
  union() {
    linear_extrude(height = flange_t) rrect2d(flange_w, flange_d, flange_r);
    translate([0, 0, flange_t - 0.01])
      linear_extrude(height = total_h - flange_t + 0.01)
        square([stem_w, stem_d], center = true);
  }
  translate([0, 0, sock_z])
    linear_extrude(height = total_h - sock_z + 0.1)
      square([sock_w, sock_d], center = true);
}

if (show_original) { %import(original_file); }
