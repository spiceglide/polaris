shader_type canvas_item;

uniform sampler2D pattern;

uniform float density = 0.1;
uniform float alpha: hint_range(0.0, 1.0) = 1.0;
uniform vec2 speed = vec2(0.8, -0.2);

uniform float fade_start: hint_range(0.0, 1.0) = 0.3;
uniform float fade_end: hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec2 uv = vec2(UV.x + TIME*speed.x, UV.y + TIME*speed.y);

	// Calculate the tile size and overlap
	vec2 tile_size = vec2(1.0 / 8.0, 1.0 / 8.0); // Change this for different tile sizes
	vec2 offset = vec2(density * tile_size.x, density * tile_size.y);

	// Calculate the UV coordinates with overlap
	vec2 tiled_uv = fract(uv / tile_size) * tile_size + offset;

	// Sample the texture
	vec4 tex_color = texture(pattern, tiled_uv);

	float fade_factor = smoothstep(fade_end, fade_start, UV.y);

	// Output the color
	COLOR = tex_color * fade_factor;
	COLOR.a *= alpha;
}