#extension GL_ARB_draw_buffers : enable
#ifdef GL_ES
precision highp float;
precision mediump int;
#endif

uniform sampler2D f_one_four;
uniform sampler2D f_five_eight;
uniform sampler2D f_zero_prev_density;
uniform sampler2D pigment;
uniform float brushSize;
uniform vec2 brushVector;
uniform vec2 brushPosition;


void main() {
  bool toBrush;
  float scale_rest = 0.001; //set to something
  float scale_direction = 0.005; //set to something
  float pigment_to_water_ratio = 0.3;
  vec2 x_y = vec2(gl_TexCoord[0].s * 1080, gl_TexCoord[0].t * 900);
  if (distance(vec(x_y.x+0.5, x_y.y+0.5), brushPosition) >= brushSize / 2.0){
    toBrush = 1.0;
  }else{
    toBrush = 0.0;
  }
  vec2 st = gl_TexCoord[0].st;
  vec4 f_one_to_four = texture2D(f_one_four, st);
  vec4 f_five_to_eight = texture2D(f_five_eight, st);
  vec4 f_zero_ = texture2D(f_zero_prev_density, st);
  vec4 pigmentData = texture2D(pigment, st);
  if(toBrush == 0.0){
    float restInc = scale_rest / length(brushVector);
    float oneInc = scale_direction * brushVector.x;
    float twoInc = scale_direction * brushVector.y;
    float threeInc = -oneInc;
    float fourInc = - twoInc;
    float fiveInc = scale_direction *(brushVector.x + brushVector.y) / sqrt(2.0);
    float sixInc = scale_direction * (brushVector.y - brushVector.x) / sqrt(2.0);
    float sevenInc = - fiveInc;
    float eightInc = -sevenInc;

    gl_FragData[0] = vec4(f_one_to_four[0] + oneInc, f_one_to_four[1] + twoInc, f_one_to_four[2] + threeInc, f_one_to_four[3] + fourInc);
    gl_FragData[1] = vec4(f_five_to_eight[0] + fiveInc, f_five_to_eight[1] + sixInc,
      f_five_to_eight[2] + sevenInc, f_five_to_eight[3] + eightInc);
    gl_FragData[2] = vec4(f_zero_[0] + restInc, f_zero_.yzw);
  } else{
    gl_FragData[0] = f_one_to_four;
    gl_FragData[1] = f_five_to_eight;
    gl_FragData[2] = f_zero_;
    gl_FragData[3] = vec4(pigmentData.x + restInc * pigment_to_water_ratio, pigmentData);
  }
}
