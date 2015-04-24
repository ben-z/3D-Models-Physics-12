length = 180;

width = 180;

base_height = 1;
cover_thickness = 2;

gap_height = 5;

cover_width = 180;
cover_length = 90;
cover_side_width = 5;

front_cover_thickness = 2;
front_cover_offset = 2;

//cylinder_bottom_radius = 3;
//cylinder_top_radius = 3;

pillar_size = 6;
pillar_offset = 0.8;

// Relative to center
//pillar_coords = [
//    [cover_width/4+10,cover_length/3],
//    [-cover_width/4-10,cover_length/3],
//    [0,0],
//    [cover_width/8+10,-cover_length/3],
//    [-cover_width/8-10,-cover_length/3],
//];
//pillar_coords = [
//    [cover_width/5/2,0],
//    [cover_width/5+cover_width/5/2,0],
//    [-cover_width/5/2,0],
//    [-(cover_width/5+cover_width/5/2),0],
//];
pillar_coords = [
    [cover_width/4,0],
    [0,0],
    [-(cover_width/4),0],
];

union(){
//base();
cover();
cover_sizes();
pillars();
}
// Pillars
module pillars(){
    for( i = [0 : len(pillar_coords) - 1] ){
        translate([
            pillar_coords[i][0],
            pillar_coords[i][1],
            0 
        ]){
            pillar();
        }
    }
}
// Pole
module pillar(){
    rotate([0,0,45])
    translate([0,0,base_height+gap_height/2+pillar_offset])
    cube(size=[pillar_size,pillar_size,gap_height-pillar_offset], center=true);
//    cylinder(h = gap_height, r1 = cylinder_bottom_radius, r2 = cylinder_top_radius, center = false);
}

// Base
module base() {
    linear_extrude(base_height) {
        polygon(
            points=[
                [-width/2, -length/2]
                ,[width/2, -length/2]
                ,[width/2, length/2]
                ,[-width/2, length/2]
                ,[-width/2, -length/2]
            ]
            ,paths=[[0, 1, 2, 3, 4]]
        );
    }
}

// Cover
module cover() {
    translate([0,0,gap_height+base_height]) {
        linear_extrude(cover_thickness) {
            polygon(
                points=[
                    [-cover_width/2, -cover_length/2]
                    ,[cover_width/2, -cover_length/2]
                    ,[cover_width/2, cover_length/2]
                    ,[-cover_width/2, cover_length/2]
                    ,[-cover_width/2, -cover_length/2]
                ]
                ,paths=[[0, 1, 2, 3, 4]]
            );
        }
    }
}

    //Cover Sides
module cover_sizes() {
    // sides
    translate([cover_width/2-cover_side_width/2,0,gap_height/2+base_height])
    cube(size = [cover_side_width,cover_length,gap_height], center = true);

    translate([-(cover_width/2-cover_side_width/2),0,gap_height/2+base_height])
    cube(size = [cover_side_width,cover_length,gap_height], center = true);
    
    // fenders
    translate([0,-(cover_length/2-front_cover_thickness/2),gap_height/2+base_height+front_cover_offset])
    cube(size = [cover_width,front_cover_thickness,gap_height-front_cover_offset], center = true);
    
    translate([0,(cover_length/2-front_cover_thickness/2),gap_height/2+base_height+front_cover_offset])
    cube(size = [cover_width,front_cover_thickness,gap_height-front_cover_offset], center = true);
}