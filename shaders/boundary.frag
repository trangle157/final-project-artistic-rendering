<<<<<<< HEAD
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
=======
#extension GL_ARB_draw_buffers : enable
#ifdef GL_ES
precision highp float;
precision mediump int;
#endif

uniform sampler2D f_one_four;
uniform sampler2D f_five_eight;
uniform sampler2D velocity_current_density;
uniform sampler2D f_zero_prev_density;
uniform vec2 offset;
uniform sampler2D height_boundary;


void main(){
  vec2 st = gl_TexCoord[0].st;
  float dx = offset.s;
  float dy = offset.t;
  float current_density = texture2D(velocity_current_density, st).b;
  float threshold = 0.05;
	vec4 tex = texture2D(height_boundary, st);
  float new_blocking_factor = tex.r;
	float isBoundary = 0.0;
  vec4 tex2 = texture2D(f_zero_prev_density, st);
	float ws = tex2.a;
  float wf = texture2D(velocity_current_density, st).a;
  if(current_density == 0.0){
    float density_1 = texture2D(velocity_current_density, st + vec2(+dx, 0.0)).b;
    float density_2 = texture2D(velocity_current_density, st + vec2(-dx, 0.0)).b;
    float density_3 = texture2D(velocity_current_density, st + vec2(0.0, +dy)).b;
    float density_4 = texture2D(velocity_current_density, st + vec2(0.0, -dy)).b;
    float density_5 = texture2D(velocity_current_density, st + vec2(+dx, +dy)).b;
    float density_6 = texture2D(velocity_current_density, st + vec2(+dx, -dy)).b;
    float density_7 = texture2D(velocity_current_density, st + vec2(-dx, +dy)).b;
    float density_8 = texture2D(velocity_current_density, st + vec2(-dx, -dy)).b;
    if(density_1 < threshold && density_2 < threshold && density_3 < threshold && density_4 < threshold &&
      density_5 < threshold && density_6 < threshold && density_7 < threshold && density_8 < threshold ){
        new_blocking_factor = 1./0.;
        isBoundary = 1.0;
      }
  }
  float new_ws = max(ws-wf, 0.0);
	gl_FragData[0] = vec4(tex2.r, new_blocking_factor, tex2.b, new_ws);
	gl_FragData[1] = vec4(tex.r, isBoundary, 0., 0.);
}
>>>>>>> bb835998d36f2d1f93f81bf989833880b6fb4bbb
