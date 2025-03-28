shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec3 color = vec3(0.0, 0.0, 0.3);
uniform float opacity: hint_range(0.0, 1.0) = 0.1;

uniform float flip_offset = 1.95;
uniform vec2 scale_factor = vec2(3.0, 2.0);

uniform float game_time: hint_range(0, 360.0);

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
	float ntime = float(game_time) / 360.0;
	float skew = mix(-45, 45, ntime);  // figure out a better transformation
	float yScale = abs(tan(mix(-1.5, 1.5, ntime)));
	uv.x += (uv.y + origin.y) * skew;
	uv.y += (uv.y + origin.y) / yScale;
	
	vec4 screen_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	vec4 mask_color = texture(TEXTURE, uv);
	screen_color.rgb = mix(screen_color.rgb, color, opacity);
	COLOR = vec4(screen_color.rgb, mask_color.a);
}
