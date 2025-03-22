shader_type canvas_item;

uniform sampler2D sprite;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec3 color = vec3(0.0, 0.0, 0.3);
uniform float opacity: hint_range(0.0, 1.0) = 0.1;

void fragment() {
	vec4 screen_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	vec4 mask_color = texture(sprite, UV);
	screen_color.rgb = mix(screen_color.rgb, color, opacity);
	COLOR = vec4(screen_color.rgb, mask_color.a);
}