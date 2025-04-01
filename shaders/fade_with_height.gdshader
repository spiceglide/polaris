shader_type canvas_item;

uniform float start: hint_range(0, 1) = 0.3;
uniform float end: hint_range(0, 1) = 1.0;
uniform float pos: hint_range(0, 2) = 0.5;

void fragment() {
	vec4 sprite = texture(TEXTURE, UV);

	//float uv = mix(0.2, 1.0, UV.y);

	float fade_factor_1 = smoothstep(start, end, UV.y);
	float fade_factor_2 = smoothstep(start, end, SCREEN_UV.y * pos);
	float fade_factor = max(fade_factor_1, fade_factor_2);
	fade_factor = mix(0.3, 1.0, fade_factor);

	sprite.a *= fade_factor;

	COLOR = sprite;
}
