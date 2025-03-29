shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec3 night_filter = vec3(0.0, 0.1, 0.3);
uniform vec2 night_interval = vec2(0.0, 0.05);
uniform vec3 twilight_filter = vec3(1.2, 1.0, 1.0);
uniform vec2 twilight_interval = vec2(0.0, 0.1);
uniform float alpha: hint_range(0.0, 1.0) = 0.5;

global uniform uint game_time;

float reflect_around(float value, float refl) {
	return refl - abs(value - refl);
}

float fade_in_out(float value, float minimum, float maximum) {
	float norm = (value - minimum) / (maximum - minimum);
	bool should_apply = value >= minimum || value <= maximum;
	return float(should_apply) * reflect_around(norm, 0.5);
}

float fade_out(float value, float minimum, float maximum) {
	float norm = 1.0 - (value - minimum) / (maximum - minimum);
	return norm;
}

void fragment() {
	float ntime = float(game_time) / 360.0;
	float gtime = reflect_around(ntime, 0.5);

	float night_curve = fade_out(gtime, night_interval.x, night_interval.y); //abs(2.0 * ntime - 1.0);
	float twilight_curve = fade_in_out(gtime, twilight_interval.x, twilight_interval.y); //abs(2.0 * ntime - 1.0) * 0.5;

	/*
	vec4 sum_filter = vec4(1.0, 1.0, 1.0, 1.0);
	sum_filter = mix(sum_filter, vec4(night_filter, night_curve), 0.5);
	sum_filter = mix(sum_filter, vec4(twilight_filter, twilight_curve), 0.5);
	*/
	vec4 sum_filter = vec4(night_filter, night_curve);
	sum_filter = mix(sum_filter, vec4(twilight_filter, twilight_curve), 0.5);

	vec4 filter = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);

	filter.rgb = mix(filter.rgb, night_filter, night_curve);
	filter.rgb = mix(filter.rgb, twilight_filter, twilight_curve);

	filter.a = max(night_curve, twilight_curve);

	filter.a *= alpha;
	COLOR = filter;
}