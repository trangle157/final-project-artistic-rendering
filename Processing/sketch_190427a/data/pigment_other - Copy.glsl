
#ifdef GL_ES
precision highp float;
precision mediump int;
#endif

uniform sampler2D f_one_four;
uniform sampler2D f_five_eight;
uniform sampler2D velocity_current_density;
uniform sampler2D f_zero_prev_density;
uniform vec2 offset;
uniform sampler2D pigment;
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

void main(){
    
    vec2 st = gl_TexCoord[0].st;
    vec3 pigment_concentration = texture2D(pigment, st).xyz;
	vec4 f1_f4 = texture2D(f_one_four, st);
    vec4 f5_f8 = texture2D(f_five_eight, st);
    vec4 f0_prev_density = texture2D(f_zero_prev_density, st);
    vec4 velocity_density = texture2D(velocity_current_density, st);

    float f1 = f1_f4.r;
    float f2 = f1_f4.g;
    float f3 = f1_f4.b;
    float f4 = f1_f4.a;
    float f5 = f5_f8.r;
    float f6 = f5_f8.g;
    float f7 = f5_f8.b;
    float f8 = f5_f8.a;

    vec2 e0 = vec2(0.0, 0.0);
    vec2 e1 = vec2(1.0, 0.0);
    vec2 e2 = vec2(0.0, 1.0);
    vec2 e3 = vec2(-1.0, 0.0);
    vec2 e4 = vec2(0.0, -1.0);
    vec2 e5 = e1 + e2;
    vec2 e6 = e2 + e3;
    vec2 e7 = e3 + e4;
    vec2 e8 = e4 + e1;
	/*
    float new_P_f = pigment_concentration.y;
    float new_P_x = pigment_concentration.z;
    float current_density = velocity_density.z;

    if (current_density > 0.){
        new_P_f = texture2D(pigment, st - offset * vec2(velocity_density.x, velocity_density.y)).y;
    } else {
      if ( texture2D(velocity_current_density, st - offset * e1).z > 0. || texture2D(velocity_current_density, st - offset * e2).z > 0. || 
texture2D(velocity_current_density, st - offset * e3).z > 0. || texture2D(velocity_current_density, st - offset * e4).z > 0. || texture2D(velocity_current_density, st - offset * e5).z > 0. ||
texture2D(velocity_current_density, st - offset * e6).z > 0. || texture2D(velocity_current_density, st - offset * e7).z > 0. || texture2D(velocity_current_density, st - offset * e8).z > 0.) {
      vec3 pigment_1 = texture2D(pigment, st - offset * e1).xyz;
      vec3 pigment_2 = texture2D(pigment, st - offset * e2).xyz;
      vec3 pigment_3 = texture2D(pigment, st - offset * e3).xyz;
      vec3 pigment_4 = texture2D(pigment, st - offset * e4).xyz;
      vec3 pigment_5 = texture2D(pigment, st - offset * e5).xyz;
      vec3 pigment_6 = texture2D(pigment, st - offset * e6).xyz;
      vec3 pigment_7 = texture2D(pigment, st - offset * e7).xyz;
      vec3 pigment_8 = texture2D(pigment, st - offset * e8).xyz;
        new_P_f = (f1 * pigment_1.y + f2 * pigment_2.y + f3 * pigment_3.y + f4 * pigment_4.y + f5 * pigment_5.y +
            f6 * pigment_6.y + f7 * pigment_7.y + f8 * pigment_8.y) ;

        }
    }
    if(f0_prev_density.z > 0.0){
    float wl = max(f0_prev_density.z - velocity_density.z, 0.);

    float water_lost = wl / f0_prev_density.z;
    }else{
      float water_lost = 0.;
    }
    float zeta = 0.1;
    float phi = 0.1;
    float P_fix = max(water_lost * (1.0 - smoothstep(0., zeta, velocity_density.z)), phi);
    float ki = 0.3;
    float mu = 0.1;
    float tau = 1.5;
    float theta = 0.1;
    float granularity = ki * (1. - smoothstep(0., mu, texture2D(height_boundary, st).x));
    if ( length(vec2(velocity_density.x, velocity_density.y)) > tau){
      P_fix =  max(P_fix - theta * velocity_density.z * pigment_concentration.z, 0.);
      new_P_f = new_P_f + P_fix;
      new_P_x = max(new_P_x - P_fix, 0.);
    }else{
      new_P_f = max(new_P_f - P_fix, 0.);
      new_P_x = new_P_x + P_fix;
    }
	*/
	
	vec3 pigment_1 = texture2D(pigment, st - offset * e1).xyz;
    vec3 pigment_2 = texture2D(pigment, st - offset * e2).xyz;
    vec3 pigment_3 = texture2D(pigment, st - offset * e3).xyz;
    vec3 pigment_4 = texture2D(pigment, st - offset * e4).xyz;
    vec3 pigment_5 = texture2D(pigment, st - offset * e5).xyz;
    vec3 pigment_6 = texture2D(pigment, st - offset * e6).xyz;
    vec3 pigment_7 = texture2D(pigment, st - offset * e7).xyz;
	vec3 pigment_8 = texture2D(pigment, st - offset * e8).xyz;
    float new_P_f = .95 * max(pigment_concentration.y, max(pigment_1.y, max(pigment_2.y, max(pigment_3.y, max(pigment_4.y, max(pigment_5.y, max(pigment_6.y, max(pigment_7.y, pigment_8.y))))))));
	float new_P_x = pigment_concentration.z;
	if (new_P_f == pigment_concentration.y * .95) {
	new_P_f = pigment_concentration.y;
	}
    gl_FragData[0] = vec4(pigment_concentration.x,  new_P_f, new_P_x, 0.0);
  
}
