$fn=50;

casing_x = 90;
casing_y = 110;
casing_z = 60;
casing_r = 10;

interior_x = 75;
interior_y = 95;
interior_z = 40;

screw_hole_r = 2;
screw_hole_xy_offset = 3.5;

battery_x = 26.7; // 26.5
battery_y = 17.7; // 17.5
battery_y_offset = 15;

switch_r = 7; // rough measure
led_r = 2.5; // unknown
led_y_offset = 5;

top_cutout_z_offset = 20;

battery_connector_x = 20;
battery_connector_z = 8;

wire_cutout_y = 10;
wire_cutout_z = 8;

bottom_cutout_z_offset = 0;
wire_cutout_y_offset = 20;

difference(){
    casing(casing_x,casing_y,casing_z,casing_r);
    interior(interior_x,interior_y,interior_z);
    screw_holes(interior_x,interior_y,interior_z,screw_hole_r,screw_hole_xy_offset,top_cutout_z_offset);
    slots(interior_x,interior_y,interior_z,top_cutout_z_offset,battery_x,battery_y,battery_y_offset,switch_r,led_r,led_y_offset);
    wire_cutouts(interior_x,interior_y,casing_z,bottom_cutout_z_offset,battery_connector_x,battery_connector_z,wire_cutout_y,wire_cutout_z,wire_cutout_y_offset);
}

// Interior of the case
module interior(x,y,z){
    // Translate it down so cutting is possible
    offset = z;
    translate([0,0,-offset/2])
        // Increasing the height for differencing
        cube(size=[x,y,z+offset], center=true);
}

// Case
module casing(x,y,z,r){
    // Actual dimensions (cylinders are centered)
    xt = (x-2*r)/2;
    yt = (y-2*r)/2;
    zt = (z-2*r)/2;
    // Get the intersection of x, y, and z pillars
    intersection(){
        // Vertical
        hull(){
            translate([-xt,yt]) cylinder(h=z,r=r,center=true);
            translate([-xt,-yt]) cylinder(h=z,r=r,center=true);
            translate([xt,yt]) cylinder(h=z,r=r,center=true);
            translate([xt,-yt]) cylinder(h=z,r=r,center=true);
        }
        // Horizontal (x)
        rotate([0,90,0]){
            hull(){
                translate([-zt,yt]) cylinder(h=x,r=r,center=true);
                translate([-zt,-yt]) cylinder(h=x,r=r,center=true);
                translate([zt,yt]) cylinder(h=x,r=r,center=true);
                translate([zt,-yt]) cylinder(h=x,r=r,center=true);
            }
        }
        // Horizontal (y)
        rotate([90,0,0]){
            hull(){
                translate([-xt,zt]) cylinder(h=y,r=r,center=true);
                translate([-xt,-zt]) cylinder(h=y,r=r,center=true);
                translate([xt,zt]) cylinder(h=y,r=r,center=true);
                translate([xt,-zt]) cylinder(h=y,r=r,center=true);
            }
        }
    }
}

// Holes for screws
module screw_holes(x,y,z,r,offset_xy,offset_z){
    xt = (x-2*r)/2-offset_xy;
    yt = (x-2*r)/2-offset_xy;
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