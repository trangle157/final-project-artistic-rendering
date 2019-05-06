uniform vec4 f1_to_f4; //check back if uniform or attribute
uniform vec4 f5_to_f8; //dist. func f5 to f8
uniform vec4 velocity_to_wf; //v.y, v.x, component density, wf(the amount of water transferred from the surface to flow layer wf)
uniform vec4 f0_to_ws; //distribution function 0, block factor k, previous density, amount of water in surface layer
uniform int h; //height field

uniform vec4 u_color;

bool isBoundary;

void main() {
	//swapping channels in a texture, not sure what this does, page sth
	gl_TexCoord[0].st + vec2(-1.0, 0.0)

	//calculate streaming function according to eq 11, page 34 chap III
   int ka = 1; //ka = (ki + k(i-ei))/2, not sure how to do that so assume = 1 
	
	int f1 = ka * f1_to_f4.x + (1-ka)*(f1_to_f4.z);
	int f3 = f1;
	int f2 = ka * f1_to_f4.y + (1-ka)*(f1_to_f4.w);
	int f4 = f2;
	int f5 = ka * f5_to_f8.x + (1-ka)*(f5_to_f8.z);
	int f7 = f5;
	int f6 = ka * f5_to_f8.y + (1-ka)*(f5_to_f8.w);
	int f8 = f6;

	//calculating evaporation amount at the boundary
	//page 34 - not sure abt this part

}
