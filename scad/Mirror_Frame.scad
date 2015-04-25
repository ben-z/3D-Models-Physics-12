//  hex_screw(10,4,55,30,1.5,2,15,8,0,0);
// Screw: http://www.thingiverse.com/thing:8796

// Inner Dimensions
length = 215;
width = 170;
depth = 4;

sides_thickness = 1;

// Lip
front_lip = 10;
lip_thickness = 1;

// Screw Holders
screw_holder_length = 30;
screw_holder_width = 20;
screw_diameter = 10;
screw_holder_offset = 40;

// Magnet Holder
magnet_holder_thickness = 5;

// Magnet Plate
magnet_plate_length = 150;
magnet_plate_padding = 3;

// Generated Dimensions
outer_length = length + sides_thickness;
outer_width = width + sides_thickness;
outer_depth = depth + sides_thickness;

c_top_left  = [- ( outer_length/2 ), outer_width/2];
c_top_right = [ outer_length/2, outer_width/2];
c_bottom_left = [- ( outer_length/2 ), - outer_width/2];
c_bottom_right = [ outer_length/2, - outer_width/2];

screw_holder_top_left  = [- ( outer_length/2 ), (outer_width/2 - screw_holder_offset)];
screw_holder_top_right = [ outer_length/2, (outer_width/2 - screw_holder_offset)];
screw_holder_bottom_left = [- ( outer_length/2 ), - (outer_width/2 - screw_holder_offset)];
screw_holder_bottom_right = [ outer_length/2, - (outer_width/2 - screw_holder_offset)];


base_plate();

translate([0,0,outer_depth+lip_thickness+magnet_holder_thickness])
rotate([180,0,0])
magnet_holder();

module magnet_holder(){
    union(){
        // Screw Holders 
        translate([screw_holder_top_right[0],screw_holder_top_right[1],0])
            screw_holder(screw_holder_length, screw_holder_width, screw_diameter+2, magnet_holder_thickness);
        translate([screw_holder_bottom_right[0],screw_holder_bottom_right[1],0])
            screw_holder(screw_holder_length, screw_holder_width, screw_diameter+2, magnet_holder_thickness);
        translate([screw_holder_top_left[0],screw_holder_top_left[1],0])
            mirror([1,0,0])
            screw_holder(screw_holder_length, screw_holder_width, screw_diameter+2, magnet_holder_thickness);
        translate([screw_holder_bottom_left[0],screw_holder_bottom_left[1],0])
            mirror([1,0,0])
            screw_holder(screw_holder_length, screw_holder_width, screw_diameter+2, magnet_holder_thickness);
        
        // Arms
        translate([0,screw_holder_top_right[1],0])
            cube(size=[outer_length, screw_holder_width, magnet_holder_thickness], center=true);
        translate([0,screw_holder_bottom_right[1],0])
            cube(size=[outer_length, screw_holder_width, magnet_holder_thickness], center=true);
        
        // Plate
        translate([0,0,magnet_plate_padding/2])
            cube(size=[magnet_plate_length, outer_width-2*screw_holder_offset, magnet_holder_thickness+magnet_plate_padding], center=true);

    }
}

module base_plate(){
    union(){
        translate([0,0,-lip_thickness/2]){
            linear_extrude(center=true, height = lip_thickness){
                lip();
            }
        }
        
        translate([0,0,outer_depth/2]){
            linear_extrude(center=true, height = outer_depth){
                sides();
            }
        }
        // Screw Holders 
        translate([screw_holder_top_right[0],screw_holder_top_right[1],(outer_depth+lip_thickness)/2-lip_thickness])
            screw_holder(screw_holder_length, screw_holder_width, screw_diameter+2, outer_depth+lip_thickness);
        translate([screw_holder_bottom_right[0],screw_holder_bottom_right[1],(outer_depth+lip_thickness)/2-lip_thickness])
            screw_holder(screw_holder_length, screw_holder_width, screw_diameter+2, outer_depth+lip_thickness);
        translate([screw_holder_top_left[0],screw_holder_top_left[1],(outer_depth+lip_thickness)/2-lip_thickness])
            mirror([1,0,0])
            screw_holder(screw_holder_length, screw_holder_width, screw_diameter+2, outer_depth+lip_thickness);
        translate([screw_holder_bottom_left[0],screw_holder_bottom_left[1],(outer_depth+lip_thickness)/2-lip_thickness])
            mirror([1,0,0])
            screw_holder(screw_holder_length, screw_holder_width, screw_diameter+2, outer_depth+lip_thickness);
    }
}
module lip(){
    square_ring(thickness = front_lip);
}

module sides(){
    square_ring(thickness = sides_thickness);
}

module screw_holder(length, width, inner_diameter, h) {
    translate([length-width/2,0,0])
    union(){
        difference() {
            cylinder(r = width/2, h = h, center=true);
            translate([ 0, 0, -1 ]) cylinder(r = inner_diameter/2, h = h+2, center=true);
        }
        difference(){
            translate([-width/2,0,0]){
                cube(center = true, size=[length-width/2,width,h], center=true);
            }
            translate([ 0, 0, -1 ]) cylinder(r = width/2, h = h+2, center=true);
        }
    }
}

module square_ring(thickness){
    
    c_top_left_inner  = [- (outer_length/2 - thickness), (outer_width/2 - thickness)];
    c_top_right_inner = [ outer_length/2 - thickness, (outer_width/2 - thickness)];
    c_bottom_left_inner = [- (outer_length/2 - thickness), - (outer_width/2 - thickness)];
    c_bottom_right_inner = [ outer_length/2 - thickness, - (outer_width/2 - thickness)];
    
    polygon(
        points=[
            c_top_left,
            c_top_right,
            c_bottom_right,
            c_bottom_left,
    
            c_top_left_inner,
            c_top_right_inner,
            c_bottom_right_inner,
            c_bottom_left_inner,

        ],
        paths=[[0,1,2,3],[4,5,6,7]]
    );
}