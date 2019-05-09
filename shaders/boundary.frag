#version 400
//texture in each cell
uniform vec4 f1_to_f4; //check back if uniform or attribute
uniform vec4 f5_to_f8; //dist. func f5 to f8
uniform vec4 velocity_to_wf; //v.y, v.x, component density, wf(the amount of water transferred from the surface to flow layer wf)
uniform vec4 f0_to_ws; //f0, block factor, previous density, ws(water in surface layer)
uniform int h; //height field

//if boundary or not
bool ifBoundary;
//color
uniform vec4 u_color;

//these are the inputs which are the outputs of the vertex shader
in vec3 brushPos;
in vec3 texCoord; //not sure what this is used for

//this is where the final pixel color is output
out vec4 out_color;

void main() {
	//swapping due to bounce back effect
	float swap = texture_one_to_four.x; //swap f1 and f3
	texture_one_to_four.x = texture_one_to_four.z;
	texture_one_to_four.z = swap;

	swap = texture_one_to_four.y; //swap f2 and f4
	texture_one_to_four.y = texture_one_to_four.w;
	texture_one_to_four.w = swap;

	//guessing from page 34
	//detect a boundary cell
	//don't know how to access the previous cell's density
	//A boundary is formed
	//when a cell with no water ( p = 0 ) is surrounded by cells whose amount of water is less
	//than some threshold n . In this case the boundary site’s blocking factor is set to infinity.
	//When any of the dry cell’s neighbors’ density rises above threshold n, the dry cell’s
	//blocking factor is reset to the height field. Additionally non-boundary sites’ blocking
 	//factors are set to the height field.

 	//temporarily set to height field before I figure this shit out
	float ki = h; 

	float new_ws = max(ws - wf, 0);
}