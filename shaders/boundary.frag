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
    density_1 = texture2D(velocity_current_density, st + vec2(+dx, 0.0)).b;
    density_2 = texture2D(velocity_current_density, st + vec2(-dx, 0.0)).b;
    density_3 = texture2D(velocity_current_density, st + vec2(0.0, +dy)).b;
    density_4 = texture2D(velocity_current_density, st + vec2(0.0, -dy)).b;
    density_5 = texture2D(velocity_current_density, st + vec2(+dx, +dy)).b;
    density_6 = texture2D(velocity_current_density, st + vec2(+dx, -dy)).b;
    density_7 = texture2D(velocity_current_density, st + vec2(-dx, +dy)).b;
    density_8 = texture2D(velocity_current_density, st + vec2(-dx, -dy)).b;
    if(density_1 < threshold && density_2 < threshold && density_3 < threshold && density_4 < threshold &&
      density_5 < threshold && density_6 < threshold && density_7 < threshold && density_8 < threshold ){
        new_blocking_factor = infinity;
        isBoundary = 1.0;
      }
  }
  float new_ws = max(ws-wf, 0.0);
	gl_FragData[0] = vec4(tex2.r, new_blocking_factor, tex2.b, new_ws);
	gl_FragData[1] = vec4(tex.r, isBoundary, 0., 0.);
}
