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

float smoothstep(float edge0, float edge1, float x) {
  if(x < edge0){
      return 0.;
} else if( x > edge1){
     return 1.;
} else{
  return edge0 * (2. * pow(x, 3.) - 3. * pow(x, 2.) + 1.) + edge1 * (-2 * pow(x, 3.) + 3. * pow(x, 2.));
}
}

void main() {
	//this will only happen if there is a boundary on the nearby cells
	vec2 st = gl_TexCoord[0].st;
  	vec4 tex1 = texture2D(f_one_four, st);
  	vec4 tex2 = texture2D(f_five_eight, st);
  	float ws = texture2D(f_zero_prev_density, st).a;
  	float f0 = texture2D(f_zero_prev_density, st).r;
  	float f1 = tex1.r;
  	float f2 = tex1.g;
  	float f3 = tex1.b;
  	float f4 = tex1.a;
  	float f5 = tex2.r;
  	float f6 = tex2.g;
  	float f7 = tex2.b;
  	float f8 = tex2.a;
  	vec2 e0 = vec2(0.0, 0.0);
  	vec2 e1 = vec2(1.0, 0.0);
  	vec2 e2 = vec2(0.0, -1.0);
  	vec2 e3 = vec2(-1.0, 0.0);
  	vec2 e4 = vec2(0.0, 1.0);
  	vec2 e5 = e1 + e2;
  	vec2 e6 = e2 + e3;
  	vec2 e7 = e3 + e4;
 	vec2 e8 = e4 + e1;

 	float current_blocking_factor = texture2D(f_zero_prev_density, st).g;
  	float isBoundary = texture2D(height_boundary, st).g;
  	float evapRate = 0.1;
  	float k_a = 0.;

  	



}