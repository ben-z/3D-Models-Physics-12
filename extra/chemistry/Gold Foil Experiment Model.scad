length = 180;

width = 180;

base_height = 1;
cover_thickness = 2;

gap_height = 5;

cover_width = 180;
cover_length = 90;
cover_side_width = 5;

cylinder_bottom_radius = 3;
cylinder_top_radius = 3;

// Relative to center
//pillar_coords = [
//    [cover_width/4+10,cover_length/3],
//    [-cover_width/4-10,cover_length/3],
//    [0,0],
//    [cover_width/8+10,-cover_length/3],
//    [-cover_width/8-10,-cover_length/3],
//];
pillar_coords = [
    [cover_width/5/2,0],
    [cover_width/5+cover_width/5/2,0],
    [-cover_width/5/2,0],
    [-(cover_width/5+cover_width/5/2),0],
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
    translate([0,0,base_height])
    cylinder(h = gap_height, r1 = cylinder_bottom_radius, r2 = cylinder_top_radius, center = false);
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
    translate([cover_width/2-cover_side_width/2,0,gap_height/2+base_height])
    cube(size = [cover_side_width,cover_length,gap_height], center = true);

    translate([-(cover_width/2-cover_side_width/2),0,gap_height/2+base_height])
    cube(size = [cover_side_width,cover_length,gap_height], center = true);
}