shader_type canvas_item;

uniform float rotation_degrees: hint_range(-180, 180) = 2.0;
uniform int fps = 2;
uniform vec2 pivot = vec2(60.0, 60.0);

void vertex() {
	float rotation_angle = rotation_degrees / 57.29578;
	bool effect = mod(TIME, float(fps)) < (float(fps) / 2.0);
	float strength = 2.0 * float(effect) - 1.0;
	rotation_angle = strength * (rotation_degrees / 57.29578);

	// Calculate the cosine and sine of the rotation angle
	float cos_angle = cos(rotation_angle);
	float sin_angle = sin(rotation_angle);
	
	// Create a rotation matrix
	mat2 rotation_matrix = mat2(vec2(cos_angle, -sin_angle),
								 vec2(sin_angle, cos_angle));

	// Calculate the vertex position relative to the pivot
	vec2 translated_position = VERTEX.xy - pivot;
	
	// Rotate the vertex position
	vec2 rotated_position = rotation_matrix * translated_position;
	
	// Update the vertex position
	VERTEX.xy = rotated_position + pivot;
}
