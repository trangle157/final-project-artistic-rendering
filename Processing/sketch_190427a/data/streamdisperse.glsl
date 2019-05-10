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

//assume that streaming disperses from this cell
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

 	  float current_blocking_factor = texture2D(f_zero_prev_density, st).g;
  	float isBoundary = texture2D(height_boundary, st).g;
  	float evapRate = 0.1;
  	float k_a = 0.05;
    float justStreamed = 1.0; //3rd element of height field set to 1
    float new_f1 = 0.;
    float new_f2= 0.;
    float new_f3 = 0.;
    float new_f4 = 0.;
    float new_f5 = 0.;
    float new_f6= 0.;
    float new_f7= 0.;
    float new_f8= 0.;


  float gotStreamed = texture2D(height_boundary, st + offset*e1).b; //check if have streaming from left cell
  if (gotStreamed) {
    new_f1 += texture2D(f_one_four, st + offset*e1).r;
  }
  //so on
  gotStreamed = texture2D(height_boundary, st + offset*e2).b; 
  if (gotStreamed) {
    new_f2 += texture2D(f_one_four, st + offset*e2).r;
  }
  gotStreamed = texture2D(height_boundary, st + offset*e3).b; 
  if (gotStreamed) {
    new_f3 += texture2D(f_one_four, st + offset*e3).r;
  }
  gotStreamed = texture2D(height_boundary, st + offset*e4).b; 
  if (gotStreamed) {
    new_f4 += texture2D(f_one_four, st + offset*e4).r;
  }
  gotStreamed = texture2D(height_boundary, st + offset*e5).b; 
  if (gotStreamed) {
    new_f5 += texture2D(f_five_eight, st + offset*e5).r;
  }
  gotStreamed = texture2D(height_boundary, st + offset*e6).b; 
  if (gotStreamed) {
    new_f6 += texture2D(f_five_eight, st + offset*e6).r;
  }
  gotStreamed = texture2D(height_boundary, st + offset*e7).b; 
  if (gotStreamed) {
    new_f7 += texture2D(f_five_eight, st + offset*e7).r;
  }
  gotStreamed = texture2D(height_boundary, st + offset*e8).b; 
  if (gotStreamed) {
    new_f8 += texture2D(f_five_eight, st + offset*e8).r;
  }

    //check if neighboring cells are boundaries, if yes --> use bounce back
    //stream all fi with bounce-back and lower the density at boundaries

    float k_opposite = texture2D(f_zero_prev_density, st + offset * e1).g;
    float ifbound = texture2D(height_boundary, st + offset * e1).g;//check if right is boundary
    if (ifbound) {
      k_a = 0.5 * current_blocking_factor + 0.5 * k_opposite;
      if (k_a == 1) {
        new_f3 = max(k_a * f3 + (1.0 - k_a) * f1 - isBoundary*evapRate, 0.);
      } else {
        new_f3 = max(k_a * f3 + (1.0 - k_a) * f1, 0.);
      }
    }

    k_opposite = texture2D(f_zero_prev_density, st + offset * e2).g;
    ifbound = texture2D(height_boundary, st + offset * e2).g; //up 
    if (ifbound) {
      k_a = 0.5 * current_blocking_factor + 0.5 * k_opposite;
      if(k_a == 1) {
        new_f4 = max(k_a * f4 + (1.0 - k_a) * f2 - isBoundary*evapRate, 0.);
      } else {
        new_f4 = max(k_a * f4 + (1.0 - k_a) * f2, 0.);
      }
    }

    k_opposite = texture2D(f_zero_prev_density, st + offset * e3).g;
    ifbound = texture2D(height_boundary, st + offset * e3).g; //down
    if (ifbound) {
      k_a = 0.5 * current_blocking_factor + 0.5 * k_opposite;
      if(k_a == 1) {
        new_f1 = max(k_a * f1 + (1.0 - k_a) * f3 - isBoundary*evapRate, 0.);
      }
      else {
        new_f1 = max(k_a * f1 + (1.0 - k_a) * f3, 0.);
      }
    }

    k_opposite = texture2D(f_zero_prev_density, st + offset * e4).g;
    ifbound = texture2D(height_boundary, st + offset * e4).g; 
    if (ifbound) {
      k_a = 0.5 * current_blocking_factor + 0.5 * k_opposite;
      if (k_a == 1) {
        new_f2 = max(k_a * f2 + (1.0 - k_a) * f4 - isBoundary*evapRate, 0.);
      }
      new_f2 = max(k_a * f2 + (1.0 - k_a) * f4, 0.);
    }

    //FIX LATER
    k_opposite = texture2D(f_zero_prev_density, st + offset * e5).g;
    ifbound = texture2D(height_boundary, st + offset * e5).g;
    if (ifbound) {
      k_a = 0.5 * current_blocking_factor + 0.5 * k_opposite;
      if (k_a == 1) {
        new_f7 = max(k_a * f2 + (1.0 - k_a) * f5 - isBoundary*evapRate, 0.);
      }
      new_f7 = max(k_a * f2 + (1.0 - k_a) * f5, 0.);
    }

    k_opposite = texture2D(f_zero_prev_density, st + offset * e6).g;
    ifbound = texture2D(height_boundary, st + offset * e6).g;
    if (ifbound) {
      k_a = 0.5 * current_blocking_factor + 0.5 * k_opposite;
      if (k_a == 1) {
        new_f8 = max(k_a * f2 + (1.0 - k_a) * f6 - isBoundary*evapRate, 0.);
      }
      new_f8 = max(k_a * f2 + (1.0 - k_a) * f6, 0.);
    }

    k_opposite = texture2D(f_zero_prev_density, st + offset * e7).g;
    ifbound = texture2D(height_boundary, st + offset * e7).g;
    if (ifbound) {
      k_a = 0.5 * current_blocking_factor + 0.5 * k_opposite;
      if (k_a == 1) {
        new_f5 = max(k_a * f2 + (1.0 - k_a) * f7 - isBoundary*evapRate, 0.);
      }
      new_f5 = max(k_a * f2 + (1.0 - k_a) * f7, 0.);
    }

    k_opposite = texture2D(f_zero_prev_density, st + offset * e8).g;
    ifbound = texture2D(height_boundary, st + offset * e8).g;
    if (ifbound) {
      k_a = 0.5 * current_blocking_factor + 0.5 * k_opposite;
      if (k_a == 1) {
        new_f6 = max(k_a * f2 + (1.0 - k_a) * f8 - isBoundary*evapRate, 0.);
      }
      new_f6 = max(k_a * f2 + (1.0 - k_a) * f8, 0.);
    }

    //also when touch boundary cells, density would change 


  //new density and velocity, copy from old shit
  vec2 u = e1 * new_f1 + e2 * new_f2 + e3 * new_f3 + e4 * new_f4 + e5 * new_f5 + e6 * new_f6 + e7 * new_f7 + e8 * new_f8;
  float new_density = f0 + new_f1 + new_f2 + new_f3 + new_f4 + new_f5 + new_f6 + new_f7 + new_f8;
  float es = 0.1;
  new_density = max(new_density - es, 0.);
  float new_wf = clamp(ws, 0.0, max(1.0 - new_density, 0.0));
  new_density = new_density + new_wf;

  float lambda = 0.3;
  float alpha = smoothstep(0., lambda, new_density);

  float f0_eq = (4./9.)*(new_density + alpha*(3.*dot(e0, u) + 9. * pow(dot(e0,u),2.)/2. - 3. * dot(u, u)/2.)); //wi = 4/9
  float f1_eq = (1./9.)*(new_density + alpha*(3.*dot(e1, u) + 9. * pow(dot(e1,u),2.)/2. - 3. * dot(u, u)/2.));
  float f2_eq = (1./9.)*(new_density + alpha*(3.*dot(e2,u) + 9. * pow(dot(e2,u),2.)/2. - 3. * dot(u, u)/2.));
  float f3_eq = (1./9.)*(new_density + alpha*(3.*dot(e3,u) + 9. * pow(dot(e3,u),2.)/2. - 3. * dot(u, u)/2.));
  float f4_eq = (1./9.)*(new_density + alpha*(3.*dot(e4,u) + 9. * pow(dot(e4,u),2.)/2. - 3. * dot(u, u)/2.));
  float f5_eq = (1./36.)*(new_density + alpha*(3.*dot(e5,u) + 9. * pow(dot(e5,u),2.)/2. - 3. * dot(u, u)/2.));
  float f6_eq = (1./36.)*(new_density + alpha*(3.*dot(e6,u) + 9. * pow(dot(e6,u),2.)/2. - 3. * dot(u, u)/2.));
  float f7_eq = (1./36.)*(new_density + alpha*(3.*dot(e7,u) + 9. * pow(dot(e7,u),2.)/2. - 3. * dot(u, u)/2.));
  float f8_eq = (1./36.)*(new_density + alpha*(3.*dot(e8,u) + 9. * pow(dot(e8,u),2.)/2. - 3. * dot(u, u)/2.));

  //update new distribution function
  float viscosity = 1.2; //viscosity change with different pigment color, here we take rose as an example
  float new_f0 = (1. - viscosity) * f0 + viscosity * f0_eq;
  new_f1 = (1.-viscosity)*new_f1 + viscosity*f1_eq;
  new_f2 = (1.-viscosity)*new_f2 + viscosity*f2_eq;
  new_f3 = (1.-viscosity)*new_f3 + viscosity*f3_eq;
  new_f4 = (1.-viscosity)*new_f4 + viscosity*f4_eq;
  new_f5 = (1.-viscosity)*new_f5 + viscosity*f5_eq;
  new_f6 = (1.-viscosity)*new_f6 + viscosity*f6_eq;
  new_f7 = (1.-viscosity)*new_f7 + viscosity*f7_eq;
  new_f8 = (1.-viscosity)*new_f8 + viscosity*f8_eq;



  gl_FragData[0] = vec4(new_f1, new_f2, new_f3, new_f4);
  gl_FragData[1] = vec4(new_f5, new_f6, new_f7, new_f8);
  gl_FragData[2] = vec4(u.x, u.y, new_density, new_wf);
  //gl_FragData[2] = vec4(u.x, u.y, 1., .1);
  gl_FragData[3] = vec4(new_f0, texture2D(f_zero_prev_density, st).g, texture2D(f_zero_prev_density, st).b, ws);
  gl_FragData[4] = vec4(tex.r,isBoundary, justStreamed, 0.);
    //new distribution function by swapping texture channels, mentioned on page 36 - 37 (pdf) 
  	//float new_f1 = texture2D(f_one_four, st + offset * e3).r;
    //float new_f2 = texture2D(f_one_four, st + offset * e4).g;
    //float new_f3 = texture2D(f_one_four, st + offset * e1).b;
    //float new_f4 = texture2D(f_one_four, st + offset * e2).a;
    //float new_f5 = texture2D(f_five_eight, st + offset * e7).r;
    //float new_f6 = texture2D(f_five_eight, st + offset * e8).g;
    //float new_f7 = texture2D(f_five_eight, st + offset * e5).b;
    //float new_f8 = texture2D(f_five_eight, st + offset * e6).a;

    //gl_FragData[0] = vec4(new_f1, new_f2, new_f3, new_f4);
    //gl_FragData[1] = vec4(new_f5, new_f6, new_f7, new_f8);

    //these weren't updated so that's fine
    //gl_FragData[2] = vec4(u.x, u.y, new_density, new_wf);
    //gl_FragData[3] = vec4(new_f0, texture2D(f_zero_prev_density, st).g, texture2D(f_zero_prev_density, st).b, ws);

    //this is where bounceback code begins
}