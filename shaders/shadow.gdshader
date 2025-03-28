shader_type canvas_item;

uniform float flip_offset = 1.95;
uniform vec2 scale_factor = vec2(3.0, 2.0);

uniform float game_time: hint_range(0, 360.0);
//uniform float skew: hint_range(-180.0, 180.0);
//uniform float yScale: hint_range(0.0, 1.0);

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
	
	vec4 texColor = texture(TEXTURE, uv);
	COLOR = texColor;
}
