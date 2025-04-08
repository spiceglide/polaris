shader_type canvas_item;

uniform float start1: hint_range(0, 1) = 0.6;
uniform float end1: hint_range(0, 1) = 0.85;

uniform float start2: hint_range(0, 1) = 0.2;
uniform float end2: hint_range(0, 1) = 0.45;

uniform float min_alpha: hint_range(0, 1) = 0.2;

void fragment() {
	vec4 sprite = texture(TEXTURE, UV);

	//float ff1 = smoothstep(start1, end1, UV.y);
	//float ff2 = smoothstep(start2, end2, SCREEN_UV.y);
	//float fade_factor = max(max(ff1, ff2), min_alpha);
	float fade_factor = 1.0 - SCREEN_UV.y;

	sprite.a *= fade_factor;
	COLOR = sprite;
}
