#ifdef GL_ES
precision highp float;
precision mediump int;
#endif


uniform sampler2D velocity_current_density;
uniform sampler2D f_zero_prev_density;

void main(){
    vec2 st = gl_TexCoord[0].st;
    vec4 f0_prev_density = texture2D(f_zero_prev_density, st);
    vec4 velocity_density = texture2D(velocity_current_density, st);

    gl_FragData[0] = vec4(f0_prev_density.x, f0_prev_density.y, velocity_density.z, f0_prev_density.w);
  
}
