$fn=50;

casing_r = 1;

interior_x = 75;
interior_y = 95;
interior_z = 30;
wall_thickness = 1;

_casing_x = interior_x + wall_thickness*2;
_casing_y = interior_y + wall_thickness*2;
_casing_z = interior_z + wall_thickness*2;

screw_hole_r = 3.1/2;
screw_hole_xy_offset = 3.5; 

battery_x = 26.7; // 26.5
battery_y = 17.7; // 17.5
battery_y_offset = 15;

switch_r = 7; // rough measure
led_r = 2.5; // unknown
led_y_offset = 5;

_top_cutout_z_offset = 20;

battery_connector_x = 20;
battery_connector_z = 8;

wire_cutout_y = 10;
wire_cutout_z = 8;

cutout_z_offset = 0;
wire_cutout_y_offset = 20;

snap_width = 10;
snap_height = 5;
snap_depth = 1;

snap_offset_y = 20;
snap_offset_z = 7.5;

switch();

module switch(){
    // Casing
    union() body();
    // Cover
    difference(){
        translate([0,0,-_casing_z/2])
            cover();
        wire_cutouts(interior_x,interior_y,_casing_z,cutout_z_offset+wall_thickness,battery_connector_x,battery_connector_z,wire_cutout_y,wire_cutout_z,wire_cutout_y_offset);
    }
}

module body(){
    difference(){
        casing(_casing_x,_casing_y,_casing_z,casing_r);
        interior(interior_x,interior_y,interior_z,wall_thickness);
        slots(interior_x,interior_y,interior_z,_top_cutout_z_offset,battery_x,battery_y,battery_y_offset,switch_r,led_r,led_y_offset);
        wire_cutouts(interior_x,interior_y,_casing_z,cutout_z_offset,battery_connector_x,battery_connector_z,wire_cutout_y,wire_cutout_z,wire_cutout_y_offset);
    snap_slots_cutout(_casing_x,interior_y,_casing_z,snap_width,snap_height,snap_depth,snap_offset_y,snap_offset_z);
    }
}

module cover(){
    x = interior_x-0.05;
    y = interior_y-0.05;
    z = snap_offset_z + snap_height/2;
    // Main Plate
    cube([x,y,wall_thickness],center=true);
    translate([0,0,z/2]){
        // Left and Right
        translate([x/2-wall_thickness/2,0]) cube([wall_thickness,y,z], center=true);
        translate([-(x/2-wall_thickness/2),0]) cube([wall_thickness,y,z], center=true);
        // Top and Bottom
        translate([0,y/2-wall_thickness/2,0]) cube([x,wall_thickness,z], center=true);
        translate([0,-(y/2-wall_thickness/2),0]) cube([x,wall_thickness,z], center=true);
        // Snap Clips
        translate([x/2+wall_thickness/2,snap_offset_y,snap_height/2]) cube([snap_depth,snap_width,snap_height], center=true);
        translate([-(x/2+wall_thickness/2),snap_offset_y,snap_height/2]) cube([snap_depth,snap_width,snap_height], center=true);
        translate([0,-interior_y/2-snap_depth/2,snap_height/2]) cube([snap_width,snap_depth, snap_height],center=true);
    }
}

// Interior of the case
module interior(x,y,z,thickness){
    translate([0,0,-thickness]){
        // Translate it down so cutting is possible
        cube(size=[x,y,z+thickness*2], center=true);
    }
}

// Case
module casing(x,y,z,r){
    // Actual dimensions (cylinders are centered)
    xt = (x-2*r)/2;
    yt = (y-2*r)/2;
    zt = (z-2*r)/2;
    // Get the intersection of x, y, and z pillars
    intersection(){
        // The rounded edges
        hull(){
            translate([-xt,yt]) round_cylinder(h=z,r=r,center=true);
            translate([-xt,-yt]) round_cylinder(h=z,r=r,center=true);
            translate([xt,yt]) round_cylinder(h=z,r=r,center=true);
            translate([xt,-yt]) round_cylinder(h=z,r=r,center=true);
        }
    }
}

module round_cylinder(h,r,center){
    translate([0,0,h/2-r]) sphere(r=r);
    translate([0,0,-(h/2-r)]) sphere(r=r);
    cylinder(h=h-2*r,r=r,center=true);
}

// Holes for screws
module screw_holes(x,y,z,r,offset_xy,offset_z){
    xt = (x-2*r)/2-offset_xy;
    yt = (y-2*r)/2-offset_xy;
    translate([0,0,offset_z]){
        translate([-xt,yt]) cylinder(h=z,r=r,center=true);
        translate([-xt,-yt]) cylinder(h=z,r=r,center=true);
        translate([xt,yt]) cylinder(h=z,r=r,center=true);
        translate([xt,-yt]) cylinder(h=z,r=r,center=true);
    }
}

module slots(x,y,z,offset_z,bat_x,bat_y,bat_y_offset,switch_r,led_r,led_y_offset){
    translate([0,0,offset_z]){
        // Battery
        translate([0,y/2-bat_y_offset])
            cube([bat_x,bat_y,z],center=true);
        // Switch
        translate([x/2/2,-led_y_offset])
            cylinder(r=switch_r,h=z,center=true);
        // LEDs
        translate([-x/2/2,-led_y_offset])
            cylinder(r=led_r,h=z,center=true);
        translate([0,-y/2/2-led_y_offset])
            cylinder(r=led_r,h=z,center=true);
    }
}

module wire_cutouts(x,y,z,offset_z,bat_x,bat_z,w_y,w_z,w_y_offset){
    
    // Battery connector cut-out
    bat_offset_z = z/2 - offset_z - bat_z/2;
    translate([0,y/2,-bat_offset_z]){
        cube([bat_x,y,bat_z],center=true);
    }

    // Wire slot
    wire_offset_z = z/2 - offset_z - w_z/2;
    translate([0,-w_y_offset,-wire_offset_z])
    cube([2*x,w_y,w_z],center=true);
}

module snap_slots_cutout(x,y,z,w,h,d,o_y,o_z){
    w = w+0.002;
    h = h+0.002;
    d = d+0.002;
    translate([0,o_y,-z/2+o_z])
        cube([x*2,w,h], center=true);
    translate([0,-y/2,-z/2+o_z])
        cube([w,y,h],center=true);
}