shader_type canvas_item;

uniform sampler2D tex: filter_linear;
uniform float burn_strength: hint_range(0.0, 1.0) = 0.7;

void fragment() {
    vec4 base_color = texture(tex, UV);
    vec4 overlay_color = vec4(0.0, 0.0, 0.0, 0.0); // You can change this to your overlay texture if needed.
    
    // Apply the linear burn formula
    vec4 result_color = base_color + overlay_color - vec4(1.0);
    result_color = clamp(result_color, 0.0, 1.0); // Clamp to valid color range

    // Mix with burn strength
    result_color = mix(base_color, result_color, burn_strength);
    
    COLOR = result_color;
}