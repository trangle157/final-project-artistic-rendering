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
	vec2 st = gl_TexCoord[0].st;
  	vec4 tex1 = texture2D(f_one_four, st);
  	vec4 tex2 = texture2D(f_five_eight, st);
    vec4 tex = texture2D(height_boundary, st);
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

 	float density = texture2D(velocity_current_density, st).b; //density
 	float u = vec2(texture2D(velocity_current_density, st).r,texture2D(velocity_current_density, st).g);  //velocity

 	float f0_eq = (4./9.)*(density + alpha*(3.*dot(e0, u) + 9. * pow(dot(e0,u),2.)/2. - 3. * dot(u, u)/2.)); //wi = 4/9
  	float f1_eq = (1./9.)*(density + alpha*(3.*dot(e1, u) + 9. * pow(dot(e1,u),2.)/2. - 3. * dot(u, u)/2.));
  	float f2_eq = (1./9.)*(density + alpha*(3.*dot(e2,u) + 9. * pow(dot(e2,u),2.)/2. - 3. * dot(u, u)/2.));
  	float f3_eq = (1./9.)*(density + alpha*(3.*dot(e3,u) + 9. * pow(dot(e3,u),2.)/2. - 3. * dot(u, u)/2.));
  	float f4_eq = (1./9.)*(density + alpha*(3.*dot(e4,u) + 9. * pow(dot(e4,u),2.)/2. - 3. * dot(u, u)/2.));
  	float f5_eq = (1./36.)*(density + alpha*(3.*dot(e5,u) + 9. * pow(dot(e5,u),2.)/2. - 3. * dot(u, u)/2.));
  	float f6_eq = (1./36.)*(density + alpha*(3.*dot(e6,u) + 9. * pow(dot(e6,u),2.)/2. - 3. * dot(u, u)/2.));
  	float f7_eq = (1./36.)*(density + alpha*(3.*dot(e7,u) + 9. * pow(dot(e7,u),2.)/2. - 3. * dot(u, u)/2.));
  	float f8_eq = (1./36.)*(density + alpha*(3.*dot(e8,u) + 9. * pow(dot(e8,u),2.)/2. - 3. * dot(u, u)/2.));

  //update new distribution function
  	float viscosity = 1.2; //viscosity change with different pigment color, here we take rose as an example
  	float new_f0 = (1. - viscosity) * f0 + viscosity * f0_eq;
  	new_f1 = (1.-viscosity)*f1 + viscosity*f1_eq;
  	new_f2 = (1.-viscosity)*f2 + viscosity*f2_eq;
  	new_f3 = (1.-viscosity)*f3 + viscosity*f3_eq;
  	new_f4 = (1.-viscosity)*f4 + viscosity*f4_eq;
  	new_f5 = (1.-viscosity)*f5 + viscosity*f5_eq;
  	new_f6 = (1.-viscosity)*f6 + viscosity*f6_eq;
  	new_f7 = (1.-viscosity)*f7 + viscosity*f7_eq;
  	new_f8 = (1.-viscosity)*f8 + viscosity*f8_eq;

  	gl_FragData[0] = vec4(new_f1, new_f2, new_f3, new_f4);
  	gl_FragData[1] = vec4(new_f5, new_f6, new_f7, new_f8);
}