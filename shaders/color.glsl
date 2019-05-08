#extension GL_ARB_draw_buffers : enable
#ifdef GL_ES
precision highp float;
precision mediump int;
#endif

uniform sampler2D sum_reflectance;
uniform sampler2D pigment;
uniform vec3 S;
uniform vec3 K;

void main(){

vec3 a = K/S + vec3(1.);
vec3 b = sqrt(pow(a, 2) - vec3(1.));
vec2 st = gl_TexCoord[0].st;
vec3 concentration = texture2D(pigment, st);
float thickness = concentration.x + concentration.y + concentration.z;
vec3 c = a * sinh(b * S * thickness) + b * cosh(b * S * thickness);
vec3 R1 = sinh(b * S * thickness) / c;
vec3 T1 = b / c;
vec3 R2 = texture2D(sum_reflectance, st).xyz;
vec3 R = R1 + pow(T1, 2) * R2 / (vec3(1.) - R1 * R2);

gl_FragData[0] = vec4(R, 1.);

}
