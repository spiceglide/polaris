/*
MIT License

Copyright (c) 2019 Thiago Amendola

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D night_lut;
uniform sampler2D twilight_lut;

uniform float night_length = 0.1;
uniform float twilight_length = 0.2;

uniform float lut_size = 16.0;
uniform float alpha : hint_range(0, 1) = 1.0;

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

// Gets interpolation percentage for color  channel using floor and diff values.
float get_interp_percent_channel(float channel_value, float floor_value, float diff_value){
	// Workaround to avoid division by zero and return zero
	float div_sign = abs(sign(diff_value));
	return (channel_value-floor_value)*div_sign/(diff_value + (div_sign-1.0));
}

// Gets interpolation percentage for color using floor and diff values.
vec3 get_interp_percent_color(vec3 color, vec3 floorc, vec3 diff){
	vec3 res = vec3(0.0);
	res.r = get_interp_percent_channel(color.r, floorc.r, diff.r);
	res.g = get_interp_percent_channel(color.g, floorc.g, diff.g);
	res.b = get_interp_percent_channel(color.b, floorc.b, diff.b);
	return res;
}

// Get interpolated color using color floor, diff and channel percentage.
vec3 get_interpolated_color(vec3 floorc, vec3 diff, float perc){
	return floorc.rgb + diff.rgb * perc;
}

// Gets LUT mapped color using trilinear interpolation.
vec4 get_lut_mapping_trilinear(vec4 old_color, sampler2D lut){
	float lut_div = lut_size - 1.0;
	// Get floor and ceil colors and diff from identity lut
	vec3 old_color_lut_base = lut_div * old_color.rgb;
	vec3 old_color_floor_vec = floor(old_color_lut_base);
	vec3 old_color_ceil_vec = ceil(old_color_lut_base);
	vec3 old_color_diff = (old_color_floor_vec - old_color_ceil_vec)/lut_div;
	vec3 old_color_percentages = get_interp_percent_color(old_color.rgb, old_color_floor_vec/lut_div, old_color_diff);
	// Get the surrounding 8 samples positions
	vec3 lut_color_fff_vec = vec3(old_color_floor_vec.r, old_color_floor_vec.g, old_color_floor_vec.b);
	vec3 lut_color_ffc_vec = vec3(old_color_floor_vec.r, old_color_floor_vec.g, old_color_ceil_vec.b);
	vec3 lut_color_fcf_vec = vec3(old_color_floor_vec.r, old_color_ceil_vec.g, old_color_floor_vec.b);
	vec3 lut_color_fcc_vec = vec3(old_color_floor_vec.r, old_color_ceil_vec.g, old_color_ceil_vec.b);
	vec3 lut_color_cff_vec = vec3(old_color_ceil_vec.r, old_color_floor_vec.g, old_color_floor_vec.b);
	vec3 lut_color_cfc_vec = vec3(old_color_ceil_vec.r, old_color_floor_vec.g, old_color_ceil_vec.b);
	vec3 lut_color_ccf_vec = vec3(old_color_ceil_vec.r, old_color_ceil_vec.g, old_color_floor_vec.b);
	vec3 lut_color_ccc_vec = vec3(old_color_ceil_vec.r, old_color_ceil_vec.g, old_color_ceil_vec.b);
	ivec2 lut_color_fff_pos = ivec2(int(lut_size*lut_color_fff_vec.b + lut_color_fff_vec.r), int(lut_color_fff_vec.g));
	ivec2 lut_color_ffc_pos = ivec2(int(lut_size*lut_color_ffc_vec.b + lut_color_ffc_vec.r), int(lut_color_ffc_vec.g));
	ivec2 lut_color_fcf_pos = ivec2(int(lut_size*lut_color_fcf_vec.b + lut_color_fcf_vec.r), int(lut_color_fcf_vec.g));
	ivec2 lut_color_fcc_pos = ivec2(int(lut_size*lut_color_fcc_vec.b + lut_color_fcc_vec.r), int(lut_color_fcc_vec.g));
	ivec2 lut_color_cff_pos = ivec2(int(lut_size*lut_color_cff_vec.b + lut_color_cff_vec.r), int(lut_color_cff_vec.g));
	ivec2 lut_color_cfc_pos = ivec2(int(lut_size*lut_color_cfc_vec.b + lut_color_cfc_vec.r), int(lut_color_cfc_vec.g));
	ivec2 lut_color_ccf_pos = ivec2(int(lut_size*lut_color_ccf_vec.b + lut_color_ccf_vec.r), int(lut_color_ccf_vec.g));
	ivec2 lut_color_ccc_pos = ivec2(int(lut_size*lut_color_ccc_vec.b + lut_color_ccc_vec.r), int(lut_color_ccc_vec.g));
	// Get gamma corrected color from LUT.
	vec3 lut_color_fff = texelFetch(lut, lut_color_fff_pos, 0).rgb;
	vec3 lut_color_ffc = texelFetch(lut, lut_color_ffc_pos, 0).rgb;
	vec3 lut_color_fcf = texelFetch(lut, lut_color_fcf_pos, 0).rgb;
	vec3 lut_color_fcc = texelFetch(lut, lut_color_fcc_pos, 0).rgb;
	vec3 lut_color_cff = texelFetch(lut, lut_color_cff_pos, 0).rgb;
	vec3 lut_color_cfc = texelFetch(lut, lut_color_cfc_pos, 0).rgb;
	vec3 lut_color_ccf = texelFetch(lut, lut_color_ccf_pos, 0).rgb;
	vec3 lut_color_ccc = texelFetch(lut, lut_color_ccc_pos, 0).rgb;
	// Calculate first level interpolations.
	vec3 lut_color_iff = get_interpolated_color(lut_color_fff, lut_color_fff - lut_color_cff , old_color_percentages.r);
	vec3 lut_color_ifc = get_interpolated_color(lut_color_ffc, lut_color_ffc - lut_color_cfc, old_color_percentages.r);
	vec3 lut_color_icf = get_interpolated_color(lut_color_fcf, lut_color_fcf - lut_color_ccf, old_color_percentages.r);
	vec3 lut_color_icc = get_interpolated_color(lut_color_fcc, lut_color_fcc - lut_color_ccc, old_color_percentages.r);
	// Calculate second level interpolations.
	vec3 lut_color_iif = get_interpolated_color(lut_color_iff, lut_color_iff - lut_color_icf, old_color_percentages.g);
	vec3 lut_color_iic = get_interpolated_color(lut_color_ifc, lut_color_ifc - lut_color_icc, old_color_percentages.g);
	// Calculate third and final interpolation.
	vec3 lut_color_iii = get_interpolated_color(lut_color_iif, lut_color_iif - lut_color_iic, old_color_percentages.b);
	// Get final color with original alpha.
	vec4 final_color = vec4(lut_color_iii, old_color.a);
	return final_color;
}

void fragment(){
	float ntime = float(game_time) / 360.0;
	float gtime = reflect_around(ntime, 0.5);

	float night_twilight = fade_out(gtime, 0.0, night_length);
	float twilight_day;
	if (gtime > night_length) { twilight_day = fade_out(gtime, night_length, twilight_length); } else { twilight_day = 1.0; };

	vec4 original_color = texture(SCREEN_TEXTURE, SCREEN_UV);

	vec4 night_color = get_lut_mapping_trilinear(original_color, night_lut);
	vec4 twilight_color = get_lut_mapping_trilinear(original_color, twilight_lut);
	vec4 filtered_color = mix(twilight_color, night_color, night_twilight);

	// Calculate filter alpha.
	vec3 diff_color = filtered_color.rgb - original_color.rgb;
	vec4 final_color = vec4(get_interpolated_color(original_color.rgb, diff_color, alpha), twilight_day);
	COLOR = final_color;
}