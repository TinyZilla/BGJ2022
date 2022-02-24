shader_type spatial;
render_mode unshaded;

uniform vec4 color : hint_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float glow_strength = 5.0;

void fragment(){
	ALBEDO = glow_strength * color.rgb;
}
