#extension GL_ARB_draw_buffers : enable
#ifdef GL_ES
precision highp float;
precision mediump int;
#endif

uniform vec2 offset;
uniform sampler2D height_boundary;

void main(){

  vec2 st = gl_TexCoord[0].st;
  float height = texture2D(height_boundary, st).x;

  //height = max(0., height - 200./255.);
  //height = height/ (55./255.);
  gl_FragData[0] = vec4(height, 1., 0., 0.);
}
