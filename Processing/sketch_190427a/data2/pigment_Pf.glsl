#ifdef GL_ES
precision highp float;
precision mediump int;
#endif

uniform sampler2D pigment;
uniform sampler2D f_zero_prev_density;


void main(){

  vec2 st = gl_TexCoord[0].st;
  vec3 pigment_concentration = texture2D(pigment, st).xyz;
  vec4 density_wf = texture2D(f_zero_prev_density, st);
  float new_P_f = (pigment_concentration.y * density_wf.z + pigment_concentration.x * density_wf.w) / (density_wf.z + density_wf.w);
  float delta_P_f = new_P_f - pigment_concentration.y;
  float new_P_s = max(pigment_concentration.x - delta_P_f, 0.);
  gl_FragData[0] = vec4(new_P_s, new_P_f, pigment_concentration.z, 0.0);

}
