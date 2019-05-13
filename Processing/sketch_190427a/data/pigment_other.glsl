#extension GL_ARB_draw_buffers : enable


#ifdef GL_ES
precision highp float;
precision mediump int;
#endif

uniform sampler2D pigment;
uniform sampler2D f_one_four;
uniform sampler2D f_five_eight;
uniform sampler2D velocity_current_density;
uniform sampler2D f_zero_prev_density;
uniform sampler2D height_boundary;
uniform vec2 offset;



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
	float scale = 1.;
	f1 = clamp(f1 * scale, 0.0, 888.8);
	f2 = clamp(f2 * scale, 0.0, 888.8);
	f3 = clamp(f3 * scale, 0.0, 888.8);
	f4 = clamp(f4 * scale, 0.0, 888.8);
	f5 = clamp(f5 * scale, 0.0, 888.8);
	f6 = clamp(f6 * scale, 0.0, 888.8);
	f7 = clamp(f7 * scale, 0.0, 888.8);
	f8 = clamp(f8 * scale, 0.0, 888.8);


    vec2 e0 = vec2(0.0, 0.0);
    vec2 e1 = vec2(1.0, 0.0);
    vec2 e2 = vec2(0.0, -1.0);
    vec2 e3 = vec2(-1.0, 0.0);
    vec2 e4 = vec2(0.0, 1.0);
    vec2 e5 = e1 + e2;
    vec2 e6 = e2 + e3;
    vec2 e7 = e3 + e4;
    vec2 e8 = e4 + e1;
	
    float new_P_f = pigment_concentration.y;
    float new_P_x = pigment_concentration.z;
    float current_density = velocity_density.z;

    if (f0_prev_density.z > 0.){
	    float x = velocity_density.x;
		float y = velocity_density.y;
		float atan2 = atan(y, x) / 3.1415926535897932384626433832795 * 180.;
		float boost = 0.0;
		if (atan2 > 32.5 && atan2 < 57.5) {
		  x = (x + boost);
		  y = (y - boost);
		}
		if (atan2 > 122.5 && atan2 < 147.5) {
		  x = (x - boost); 
		  y = (y - boost);
		}
		if (atan2 > 212.5 && atan2 < 237.5) {
		  x = (x - boost);
		  y = (y + boost);
		}
		if (atan2 > 302.5 && atan2 < 327.5) {
		  x = (x + boost);
		  y = (y + boost);
		}
		
		
		if (texture2D(height_boundary, st - offset * vec2(x, y)).y == 0.0) {
		  new_P_f = texture2D(pigment, st - offset * vec2(x, y)).y;
		}
    } else {
	  if(f0_prev_density.z == 0.0 && current_density > 0.0) {
      
      
	    vec3 pigment_1 = texture2D(pigment, st - offset * e1).xyz;
        vec3 pigment_2 = texture2D(pigment, st - offset * e2).xyz;
        vec3 pigment_3 = texture2D(pigment, st - offset * e3).xyz;
        vec3 pigment_4 = texture2D(pigment, st - offset * e4).xyz;
        vec3 pigment_5 = texture2D(pigment, st - offset * e5).xyz;
        vec3 pigment_6 = texture2D(pigment, st - offset * e6).xyz;
        vec3 pigment_7 = texture2D(pigment, st - offset * e7).xyz;
        vec3 pigment_8 = texture2D(pigment, st - offset * e8).xyz;
        new_P_f = (f1 * pigment_1.y + f2 * pigment_2.y + f3 * pigment_3.y + f4 * pigment_4.y + f5 * pigment_5.y +
            f6 * pigment_6.y + f7 * pigment_7.y + f8 * pigment_8.y) / current_density;
      }
    }
	float water_lost;
    if(f0_prev_density.z > 0.0){
    float wl = max(f0_prev_density.z - velocity_density.z, 0.);

     water_lost = wl / f0_prev_density.z;
    }else{
       water_lost = 0.;
    }
    float zeta = .5;
    float phi = 0.0030; //.00075 //.001
    float P_fix = max(water_lost * (1.0 - smoothstep(0., zeta, velocity_density.z)), phi);
	float maxpercentdeposit = .001;
    //float ki = 0.004;
	float ki = 0.004; //.0018
    float mu = .50; //.49
    float tau = .27; //.13
    float theta = 0.028; //.008
    float granularity = ki * (1. - smoothstep(0., mu, texture2D(height_boundary, st).x));
    
	if ( length(velocity_density.xy) > tau * .5){
	  P_fix = clamp(P_fix, phi, new_P_f * maxpercentdeposit + phi);
	  P_fix = min(P_fix, new_P_f);
	  float backrun = clamp(length(velocity_density.xy) / tau, 0.0, 1.0) * theta * velocity_density.z * new_P_x;
	  backrun = clamp(backrun, 0.0, min(new_P_x, .15));
	  new_P_f = new_P_f - P_fix + backrun;
	  new_P_x = new_P_x + P_fix - backrun;
    }else{
	  P_fix = max(P_fix, granularity);
	  if (P_fix == granularity) {
	    P_fix = clamp(P_fix, phi, new_P_f * maxpercentdeposit * 1000. + phi) * exp(- new_P_x * 0.);
	  }
	  else {
	    P_fix = clamp(P_fix, phi, new_P_f * maxpercentdeposit * 2. + phi);
	  }
	  P_fix = min(P_fix, new_P_f);
      new_P_f = new_P_f - P_fix;
	  new_P_x = new_P_x + P_fix;
    }
	
	/*
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
	*/
    gl_FragData[0] = vec4(pigment_concentration.x,  new_P_f, new_P_x, 0.0);

  
}

