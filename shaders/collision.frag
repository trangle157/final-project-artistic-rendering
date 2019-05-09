#version 400
uniform sampler2D tex0; //check back if uniform or attribute
uniform sampler2D tex1; //dist. func f5 to f8
uniform sampler2D tex2; //v.x, v.y, component density, wf(the amount of water transferred from the surface to flow layer wf)
uniform sampler2D tex3; //distribution function 0, block factor k, previous density, amount of water in surface layer
uniform sampler2D tex4; //height field

uniform vec4 u_color;

bool isBoundary;


void main() {
	vec4 e0 = (0.0, 0.0, 0.0, 0.0); 
	vec4 e1 = (1.0, 0.0, 0.0, 0.0);
	vec4 e2 = (0.0, 1.0, 0.0, 0.0);
	vec4 e3 = (-1.0, 0.0, 0.0, 0.0);
	vec4 e4 = (0.0, -1.0, 0.0, 0.0);
	vec4 e5 = e1 + e2;
	vec4 e6 = e2 + e3;
	vec4 e7 = e3 + e4;
	vec4 e8 = e4 + e1;

	vec2 x_y = gl_TexCoord[0].st;
	vec4 f1_to_f4 = texture2D(tex0, x_y);
	vec4 f5_to_f8 = texture2D(tex1, x_y);
	vec4 velocity_to_wf = texture2D(tex2, x_y);
	vec4 f0_to_ws = texture2D(tex3, x_y);
	float height = texture2D(tex4, x_y).s;

	//example dist. f1 equilibrium, likewise with other distribution func
	//func as implemented in equation 13 page 36
	//wi varies with fi 
	vec4 velocity = vec4(velocity_to_wf.x, velocity_to_wf.y, 0.0, 0.0);
	//0.1 <= lambda <= 0.6
	float lambda = 0.5;
	float alpha = smoothstep(0, lambda, velocity_to_wf.z);
	float p0 = f0_to_ws.z; //previous density

	float f0_eq = (4/9)*(velocity_to_wf.z + p0*alpha*(3*dot(e0,velocity) + 9 * pow(dot(e0,velocity),2)/2 - 3 * dot(u, u)/2)); //wi = 4/9
	float f1_eq = (1/9)*(velocity_to_wf.z + p0*alpha*(3*dot(e1,velocity) + 9 * pow(dot(e1,velocity),2)/2 - 3 * dot(u, u)/2));
	float f2_eq = (1/9)*(velocity_to_wf.z + p0*alpha*(3*dot(e2,velocity) + 9 * pow(dot(e2,velocity),2)/2 - 3 * dot(u, u)/2));
	float f3_eq = (1/9)*(velocity_to_wf.z + p0*alpha*(3*dot(e3,velocity) + 9 * pow(dot(e3,velocity),2)/2 - 3 * dot(u, u)/2));
	float f4_eq = (1/9)*(velocity_to_wf.z + p0*alpha*(3*dot(e4,velocity) + 9 * pow(dot(e4,velocity),2)/2 - 3 * dot(u, u)/2));
	float f5_eq = (1/36)*(velocity_to_wf.z + p0*alpha*(3*dot(e5,velocity) + 9 * pow(dot(e5,velocity),2)/2 - 3 * dot(u, u)/2));
	float f6_eq = (1/36)*(velocity_to_wf.z + p0*alpha*(3*dot(e6,velocity) + 9 * pow(dot(e6,velocity),2)/2 - 3 * dot(u, u)/2));
	float f7_eq = (1/36)*(velocity_to_wf.z + p0*alpha*(3*dot(e7,velocity) + 9 * pow(dot(e7,velocity),2)/2 - 3 * dot(u, u)/2));
	float f8_eq = (1/36)*(velocity_to_wf.z + p0*alpha*(3*dot(e8,velocity) + 9 * pow(dot(e8,velocity),2)/2 - 3 * dot(u, u)/2));

	//update new distribution function
	float viscosity = 0.0257 //viscosity change with different pigment color, here we take rose as an example
	float new_f1 = (1-viscosity)*f1_to_f4.x + viscosity*f1_eq;
	float new_f2 = (1-viscosity)*f1_to_f4.y + viscosity*f2_eq;

	//etc
}

