base_width = 10;
top_width = 8;
height = 8;
extrusion = 10;

slot_height= 1.5;
slot_width= 2;

//cube(size=[base_length,width,height], center=true);

linear_extrude(extrusion)
polygon([
    [-base_width/2,0]
    ,[base_width/2,0]
    ,[top_width/2,height]
    ,[slot_width/2, height]
    ,[slot_width/2, height-slot_height]
    ,[-slot_width/2, height-slot_height]
    ,[-slot_width/2, height]
    ,[-top_width/2,height]
]);