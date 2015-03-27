text_line_one = "Deflection";
text_line_two = "Guide";
sub_text = "F-18";

length = 120.43;

width = 37.68;

side_width = 21.54;

height = 2;

text_size = 5;

font = "Liberation Sans:style=Bold";

linear_extrude(height=height){
    difference(){
        polygon(points=[[0,0],[side_width,0],[width,length/2],[side_width,length],[0,length]]);
        
        translate([width/8,length/4*3+length/8,0]){
            rotate([0,0,270])
            text(text=text_line_one, size=text_size, font=font);
        }
        translate([width/8,length/4*2+length/16,0]){
            rotate([0,0,270])
            text(text=text_line_two, size=text_size, font=font);
        }
        translate([width/8,length/4+10,0]){
            rotate([0,0,270])
            text(text=sub_text, size=text_size, font=font);
        }
    }
}