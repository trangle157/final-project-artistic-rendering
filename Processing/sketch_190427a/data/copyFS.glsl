
uniform sampler2D src_tex_unit0; // previous paint result

void main(void) // fragment
{
	vec4 prev = texture2D(src_tex_unit0,gl_TexCoord[0].st);
    gl_FragColor = prev;
}
