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

    //this only happens when there is boundary factors
    if (isBoundary) {
      //float k_1 = texture2D(f_zero_prev_density, st - offset * e1).g;
      float density_1 = texture2D(velocity_current_density, st + vec2(+dx, 0.0)).b;
      float density_2 = texture2D(velocity_current_density, st + vec2(-dx, 0.0)).b;
      float density_3 = texture2D(velocity_current_density, st + vec2(0.0, +dy)).b;
      float density_4 = texture2D(velocity_current_density, st + vec2(0.0, -dy)).b;
      float density_5 = texture2D(velocity_current_density, st + vec2(+dx, +dy)).b;
      float density_6 = texture2D(velocity_current_density, st + vec2(+dx, -dy)).b;
      float density_7 = texture2D(velocity_current_density, st + vec2(-dx, +dy)).b;
      float density_8 = texture2D(velocity_current_density, st + vec2(-dx, -dy)).b;

      //if blocked downward
      if()
      float new_f1 = 
    }
    



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