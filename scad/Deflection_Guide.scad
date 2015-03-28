text_line_one = "Deflection Guide · F-18";

length = 120.43;

width = 37.68;

side_width = 21.54;

height = 2;

text_size = 7;

font = "Helvetica Neue:style=bold";

text_offset = 7;

linear_extrude(height=height){
    difference(){
        polygon(points=[[0,0],[side_width,0],[width,length/2],[side_width,length],[0,length]]);
        
        translate([text_offset,length/4*2,0]){
            rotate([0,0,270])
            text(text=text_line_one, size=text_size, font=font, halign="center");
        }
    }
}