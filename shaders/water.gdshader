shader_type canvas_item;

uniform vec4 bg_color: source_color = vec4(0.14, 0.43, 0.53, 1.0);
uniform float size: hint_range(0.0, 1000.0) = 100.0;
uniform float prob: hint_range(0.0, 1.0) = 0.9;

float rand(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	vec2 pos = floor(1.0 / size * FRAGCOORD.xy);
	float color = 0.0;
	float starValue = rand(pos);
	
	if (rand(SCREEN_UV.xy / 20.0) > 0.996)
	{
		float r = rand(SCREEN_UV.xy);
		color = 0.5 * r * (0.85 * sin(TIME * (r * 5.0) + 720.0 * r) + 0.95);
	}
	COLOR = vec4(vec3(color),1.0) + bg_color;
}