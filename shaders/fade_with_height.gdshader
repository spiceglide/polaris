shader_type canvas_item;

uniform float start: hint_range(0, 1) = 0.5;
uniform float end: hint_range(0, 1) = 1.0;

uniform float min_alpha: hint_range(0, 1) = 0.1;

void fragment() {
	vec4 sprite = texture(TEXTURE, UV);

	float ff1 = smoothstep(start, end, UV.y);
	float ff2 = smoothstep(SCREEN_UV.y, 1.0, UV.y);
	float fade_factor = max(max(ff1, ff2), min_alpha);

	sprite.a *= fade_factor;

	COLOR = sprite;
}