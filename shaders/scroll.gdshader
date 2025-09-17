shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

uniform float scroll_speed : hint_range(0, 2) = 0.08;
uniform float angle_degrees : hint_range(0, 360) = 45.0;
uniform float repeat_x : hint_range(1.0, 20) = 2;
uniform float repeat_y : hint_range(1.0, 20) = 2;
uniform float row_offset : hint_range(0, 1) = 1;
uniform bool uv_mode = false;
uniform vec4 color: source_color = vec4(1.0, 1.0, 1.0, 0.0);
uniform sampler2D texture_to_scroll;

void fragment() {
 float angle_rad = radians(angle_degrees);

 vec2 direction = vec2(cos(angle_rad), sin(angle_rad));

 vec2 offset_uv = (uv_mode ? SCREEN_UV : UV) - (TIME * scroll_speed * direction);

 float offset = fract(floor(offset_uv.y * repeat_y) * 0.5) > 0.0 ? (row_offset * 0.324) : 0.0;

 offset_uv.x += offset;

 vec2 scaled_uv = vec2(fract(offset_uv.x * repeat_x),
              fract(offset_uv.y * repeat_y));

 vec2 texelSize = vec2(1.0) / vec2(textureSize(texture_to_scroll, 0));
 vec2 snappedUV = round(scaled_uv / texelSize) * texelSize;

 COLOR = texture(texture_to_scroll, snappedUV) * color;
}