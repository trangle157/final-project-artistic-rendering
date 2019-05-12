#extension GL_ARB_draw_buffers : enable

#ifdef GL_ES
precision highp float;
precision mediump int;
#endif

uniform sampler2D pigment;
uniform sampler2D velocity_current_density;
uniform sampler2D f_zero_prev_density;

void main(){

  vec2 st = gl_TexCoord[0].st;
  vec4 pigment_concentration = texture2D(pigment, st);
  
  vec4 density_wf = texture2D(velocity_current_density, st);
  float curr_density = density_wf.z;
  float wf = density_wf.w;
  float ws = texture2D(f_zero_prev_density, st).a;
  float basemovement = 0.007;
  float pigment_moved = 0.;
  if (wf > 0.0){
	pigment_moved = wf / (wf + ws) * pigment_concentration.x + basemovement;
	pigment_moved = min(pigment_moved, pigment_concentration.x);
	float new_P_f = pigment_concentration.y + pigment_moved;
    float new_P_s = pigment_concentration.x - pigment_moved;
    gl_FragData[0] = vec4(new_P_s, new_P_f, pigment_concentration.z, pigment_concentration.w);
  }
  else if (curr_density > 0.0) {
    pigment_moved = clamp(pigment_concentration.x, 0.0, basemovement);
	float new_P_f = pigment_concentration.y + pigment_moved;
    float new_P_s = pigment_concentration.x - pigment_moved;
    gl_FragData[0] = vec4(new_P_s, new_P_f, pigment_concentration.z, pigment_concentration.w);
  }
  else {
    float new_P_f = pigment_concentration.y + pigment_moved;
    float new_P_s = pigment_concentration.x - pigment_moved;
    gl_FragData[0] = vec4(new_P_s, new_P_f, pigment_concentration.z, pigment_concentration.w);
  }
  
  //gl_FragData[0] = vec4(0, 1. * pigment_concentration.x + pigment_concentration.y, pigment_concentration.z, 0.);

}
