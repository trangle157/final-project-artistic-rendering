uniform vec4 f1_to_f4; //check back if uniform or attribute
uniform vec4 f5_to_f8; //dist. func f5 to f8
uniform vec4 velocity_to_wf; //v.y, v.x, component density, wf(the amount of water transferred from the surface to flow layer wf)
uniform vec4 f0_to_ws; //f0, block factor, previous density, ws(water in surface layer)
uniform int h; //height field

bool isBoundary;

//velocity vector of lattice at ei, in which e0 is the center = (0.0, 0.0, 0.0, 0.0), may not need
uniform vec4 e0 = (0.0, 0.0, 0.0, 0.0); 
uniform vec4 e1 = e0 + (1.0, 0.0, 0.0, 0.0);
uniform vec4 e2 = e0 + (0.0, 1.0, 0.0, 0.0);
uniform vec4 e3 = e0 + (-1.0, 0.0, 0.0, 0.0);
uniform vec4 e4 = e0 + (0.0, -1.0, 0.0, 0.0);
uniform vec4 e5 = e1 + e2;
uniform vec4 e6 = e2 + e3;
uniform vec4 e7 = e3 + e4;
uniform vec4 e8 = e4 + e1;

void main() {
	//update velocity
	vec4 
	float p0 = 1.0 //initial density
	vec2 u = e1*f1_to_f4.x + e2 * f1_to_f4.y + e3 * f1_to_f4.z + e4 * f1_to_f4.w + e5 * f5_to_f8.x + e6 * f5_to_f8.y + e7 * f5_to_f8.z + e8 * f5_to_f8.w; //follow equation 2 chapter II
	float p = f1_to_f4.x + f1_to_f4.y + f1_to_f4.z + f1_to_f4.w + f5_to_f8.x + f5_to_f8.y + f5_to_f8.z + f5_to_f8.w; //equation 1 chapter II 

	int es = 0.5 //search gg for an evaporation rate, could be changed
	float evaporated = max(p - es, 0);//update equation in page 35
	int beta = 1; //how much water in the fibers in the paper can hold
	int wf = clamp(f0_to_ws.w, 0, max(beta - p, 0)); 

	p = p + wf;

	velocity_to_wf = vec4(u.x, u.y, p, velocity_to_wf.w); 
}