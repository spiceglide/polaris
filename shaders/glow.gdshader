shader_type canvas_item;
render_mode blend_premul_alpha;

uniform vec4 color: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float strength: hint_range(0.0, 8.0, 0.1) = 1.7;
uniform float shift: hint_range(1.0, 10.0, 1.0) = 1.0;
uniform float radius: hint_range(1.0, 10.0, 1.0) = 8.0;

void fragment() {
	vec4 glow = vec4(0.0);
	float count = 0.0;
	for (float x = -radius; x <= radius; x += 1.0) {
		for (float y = -radius; y <= radius; y += 1.0) {
			vec2 offset = vec2(x, y) * shift * TEXTURE_PIXEL_SIZE;
			glow += texture(TEXTURE, UV + offset) * color;
			count += 1.0;
		}
	}

	glow *= strength / count;
	COLOR = mix(texture(TEXTURE, UV), glow, glow.a);
}