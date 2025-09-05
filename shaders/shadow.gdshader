shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec3 color = vec3(0.0, 0.0, 0.0);
uniform float alpha: hint_range(0.0, 1.0) = 0.015;

instance uniform float flip_offset = 2.0;
uniform float shadow_height = 0.2;
uniform float end_angle = 45.0;
uniform vec2 scale_factor = vec2(4.0, 2.0);
uniform vec2 fade_interval = vec2(0.0, 0.05);

global uniform float game_time;

float reflect_around(float value, float refl) {
	return refl - abs(value - refl);
}

float fade_in(float value, float minimum, float maximum) {
	float norm = (value - minimum) / (maximum - minimum);
	return norm;
}

void vertex() {
	VERTEX.xy *= scale_factor;
}

void fragment() {
	// Getting UV coordinates based on screen size
	vec2 uv = (UV - 0.5) * scale_factor + 0.5;

	// Flip vertically along the bottom
	uv.y = flip_offset - uv.y;

	// Skew effect
	vec2 origin = vec2(0.5, -1.0);
	float ntime = game_time / 360.0;
	float skew = mix(-end_angle/4.0, end_angle/4.0, ntime);
	uv.x += (uv.y + origin.y) * skew;
	uv.y += (uv.y + origin.y) / shadow_height;

	// Fade effect
	float gtime = reflect_around(ntime, 0.5);
	float fade = fade_in(gtime, fade_interval.x, fade_interval.y);

	vec4 screen_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	vec4 mask_color = texture(TEXTURE, uv);
	screen_color.rgb = mix(screen_color.rgb, color, alpha*fade);
	COLOR = vec4(screen_color.rgb, mask_color.a);
}