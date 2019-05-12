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

float min_dist(vec2 v, vec2 w, vec2 p) {
  float l = distance(v, w);
  float l2 = l * l;  
  // We clamp t from [0,1] to handle points outside the segment vw.
  //float tail = -1.5 / l - .05;
  float tail = 0.0;
  float t = clamp(dot(p - v, w - v) / l2, tail, 1.0);
  vec2 projection = v + t * (w - v);  // Projection falls on the segment
  return distance(p, projection);
}

void main() {
  bool toBrush;
  float scale_rest = .1; //set to something
  float scale_direction = .023; //set to something
  float pigment_to_water_ratio = 0.03;
  float minf = .085;
  float maxf = .22;
  vec2 x_y = vec2(gl_TexCoord[0].s * 1080., gl_TexCoord[0].t * 900.);
  float dist = min_dist(brushPosition - brushVector, brushPosition, x_y);
  if (dist > brushSize / 2.0){
    toBrush = false;
  }else{
    toBrush = true;
  }
  vec2 st = gl_TexCoord[0].st;
  vec4 f_one_to_four = texture2D(f_one_four, st);
  vec4 f_five_to_eight = texture2D(f_five_eight, st);
  vec4 f_zero_ = texture2D(f_zero_prev_density, st);
  vec4 pigmentData = texture2D(pigment, st);
  
  if(toBrush){
  vec2 scaledvector = brushVector * scale_direction;
    pigment_to_water_ratio = max(0.0, pigment_to_water_ratio - .0003 * pow(1.13, dist));
    float restInc = scale_rest;
    float oneInc = clamp(scaledvector.x, minf, maxf);
    float twoInc = clamp(- scaledvector.y, minf, maxf);
    float threeInc = clamp(- scaledvector.x, minf, maxf);
    float fourInc = clamp(scaledvector.y, minf, maxf);
	float fiveInc = clamp(scaledvector.x - scaledvector.y, minf * 2., maxf * 2.) / sqrt(2.0);
    float sixInc = clamp(- scaledvector.x - scaledvector.y, minf * 2., maxf * 2.) / sqrt(2.0);
    float sevenInc = clamp(- scaledvector.x + scaledvector.y, minf * 2., maxf * 2.) / sqrt(2.0);
    float eightInc = clamp(scaledvector.x + scaledvector.y, minf * 2., maxf * 2.) / sqrt(2.0);
    float retain = .50;
    gl_FragData[0] = vec4(retain * f_one_to_four.x + oneInc, retain * f_one_to_four.y + twoInc,retain *  f_one_to_four.z + threeInc,
	  retain * f_one_to_four.w + fourInc);
    gl_FragData[1] = vec4(retain * f_five_to_eight.x + fiveInc, retain * f_five_to_eight.y + sixInc,
      retain * f_five_to_eight.z + sevenInc, retain * f_five_to_eight.w + eightInc);
    gl_FragData[2] = vec4(retain * f_zero_.x + restInc, f_zero_.y, f_zero_.z, .5 * f_zero_.w + 5. * pigment_to_water_ratio);
    gl_FragData[3] = vec4(.5 * pigmentData.x + pigment_to_water_ratio, pigmentData.y, pigmentData.z, 0.0);
  } else{
    gl_FragData[0] = f_one_to_four;
    gl_FragData[1] = f_five_to_eight;
    gl_FragData[2] = f_zero_;
    gl_FragData[3] = pigmentData;
  }
}


