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
  float threshold = 1.0;
  float root2threshold = threshold * sqrt(2.);
  vec4 tex = texture2D(height_boundary, st);
  float new_blocking_factor = max(0.0, tex.r / 100 - 0.);
  float isPinned = 0.0;
  vec4 tex2 = texture2D(f_zero_prev_density, st);
  float wf = texture2D(velocity_current_density, st).a;
  float density_1 = texture2D(velocity_current_density, st + vec2(+dx, 0.0)).b;
  float density_3 = texture2D(velocity_current_density, st + vec2(-dx, 0.0)).b;
  float density_4 = texture2D(velocity_current_density, st + vec2(0.0, +dy)).b;
  float density_2 = texture2D(velocity_current_density, st + vec2(0.0, -dy)).b;
  float density_8 = texture2D(velocity_current_density, st + vec2(+dx, +dy)).b;
  float density_5 = texture2D(velocity_current_density, st + vec2(+dx, -dy)).b;
  float density_7 = texture2D(velocity_current_density, st + vec2(-dx, +dy)).b;
  float density_6 = texture2D(velocity_current_density, st + vec2(-dx, -dy)).b;

  if(current_density == 0.0){
    if (density_1 < threshold && density_2 < threshold && density_3 < threshold && density_4 < threshold && density_5 < root2threshold && density_6 < root2threshold && density_7 < root2threshold && density_8 < root2threshold) {
      isPinned = 1.0;
	  new_blocking_factor = 60000.0;
    }
  }
  gl_FragData[0] = vec4(tex2.r, new_blocking_factor, tex2.b, tex2.a);
  gl_FragData[1] = vec4(tex.r, isPinned, 0., 0.);
}
