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
		f1 += texture2D(f_one_four, st + offset*e1).r;
	}
	//so on
	gotStreamed = texture2D(height_boundary, st + offset*e2).b; 
	if (gotStreamed) {
		f2 += texture2D(f_one_four, st + offset*e2).r;
	}
	gotStreamed = texture2D(height_boundary, st + offset*e3).b; 
	if (gotStreamed) {
		f3 += texture2D(f_one_four, st + offset*e3).r;
	}
	gotStreamed = texture2D(height_boundary, st + offset*e4).b; 
	if (gotStreamed) {
		f4 += texture2D(f_one_four, st + offset*e4).r;
	}
	gotStreamed = texture2D(height_boundary, st + offset*e5).b; 
	if (gotStreamed) {
		f5 += texture2D(f_five_eight, st + offset*e5).r;
	}
	gotStreamed = texture2D(height_boundary, st + offset*e6).b; 
	if (gotStreamed) {
		f6 += texture2D(f_five_eight, st + offset*e6).r;
	}
	gotStreamed = texture2D(height_boundary, st + offset*e7).b; 
	if (gotStreamed) {
		f7 += texture2D(f_five_eight, st + offset*e7).r;
	}
	gotStreamed = texture2D(height_boundary, st + offset*e8).b; 
	if (gotStreamed) {
		f8 += texture2D(f_five_eight, st + offset*e8).r;
	}
}